# Minimal Reproducible Example: the egress firewall starves the Codespaces network-backed filesystem

**Repository:** `nicomarr/safer-codespace`
**Tracks:** issue #23 (stop-wedge / I/O faults / post-resume data loss)
**Status of claim:** the root-cause *mechanism* is confirmed (causal A/B). The storage-allow *fix* is non-deterministic (see Reproduction status). This document lets a third party reproduce it independently on a fresh Codespace.

> **Reproduction status (verified 2026-06-15, n=3 on `main`).** Test 1 (mechanism) reproduces reliably: firewall DROP faults filesystem reads, ACCEPT fixes them instantly, and the backend is Azure Storage `:443`. The stop-wedge reproduces. **Test 2's storage-allow is NOT a reliable fix:** identical storage-only stops both wedged and completed cleanly across instances, because the stop needs rotating Azure Storage ranges that may fall outside the set you observed. Full write-up: `issue-23-reproduction-results-2026-06-15.md`.

---

## Claim being tested

A GitHub Codespace's container filesystem is backed by **Azure Storage over the network**. That traffic transits the firewall's `OUTPUT` chain. With the template's default-DROP egress firewall active:

- Cached reads keep working (so a codespace *looks* fine at first), but any read that misses page cache cannot reach the backing store and **faults**: `Input/output error` (EIO) on ordinary reads, `Bus error` (SIGBUS) on `mmap`.
- The same blocked storage path is what a **stop** cannot flush to (the multi-hour `ShuttingDown` wedge) and what a **resume** cannot read back (recovery mode, empty workspace, lost uncommitted work).

The minimal test is a two-way A/B: **closing the firewall faults filesystem reads; opening it fixes them instantly.** A second test ties this to the stop-wedge, though (per the Reproduction status) allowlisting the observed ranges only *sometimes* yields a clean stop, because the ranges the stop needs rotate.

---

## Safety and prerequisites

> [!WARNING]
> **This procedure can destroy the codespace and any uncommitted work in it.** A wedged stop can take 35 minutes to 4+ hours and a post-wedge resume can come back in recovery mode with the workspace gone. Use a **throwaway codespace with nothing of value in it**, and `git push` anything you care about first.

You need:

- Ability to create a Codespace on `nicomarr/safer-codespace` (it is a public template) or on your own copy of it.
- The `gh` CLI authenticated **on your local machine** (the stop/timing commands run there, not inside the container; the template deliberately ships no `gh` inside the sandbox).
- ~30-45 minutes, mostly passive waiting.

Throughout: commands marked **[codespace]** run in the Codespace terminal (browser VS Code); commands marked **[local]** run in your own machine's terminal.

---

## Setup: fresh codespace, confirm the firewall is active

**[local]**
```bash
gh codespace create -R nicomarr/safer-codespace -b main
# (or point -R at your own copy of the template)
# wait until `gh codespace list` shows it Available, then open it in the browser
```

**[codespace]**
```bash
sudo iptables -L OUTPUT -n | head -1        # expect: Chain OUTPUT (policy DROP)
bash tests/codespace/verify-firewall.sh     # baseline: positive controls pass, negatives blocked
```

If the policy is not `DROP`, the firewall did not come up; re-run `sudo --preserve-env=GITHUB_TOKEN bash .devcontainer/init-firewall.sh` before continuing.

---

## Test 1: Mechanism (fast, non-destructive): storage-starvation A/B

This is the core proof and it destroys nothing. It shows filesystem reads fault under DROP and recover under ACCEPT.

### 1a/1b. Run the A/B in one block

Paste this whole block into the Codespace terminal. It prints a heading first
(the page-cache drop makes the reads pause for a moment, and the message tells
you that is expected so you do not Ctrl-C), then reads `/usr/bin/date` once with
the firewall up and once with it open.

**[codespace]**
```bash
echo ">>> Storage-starvation A/B (~5s). Dropping the page cache makes the first"
echo ">>> reads pause briefly - this is NOT a hang, do not press Ctrl-C."
echo ">>> Under the firewall, 'Input/output error' is the expected (buggy) result."
echo

echo "=== BEFORE: firewall active (policy DROP) ==="
sudo sh -c 'sync; echo 3 > /proc/sys/vm/drop_caches' 2>/dev/null || echo "(drop_caches not permitted)"
for ((i=0; i<6; i++)); do /usr/bin/date 2>&1; done

echo
echo "=== AFTER: firewall opened (OUTPUT ACCEPT + flush) ==="
sudo iptables -P OUTPUT ACCEPT; sudo iptables -F OUTPUT
sudo sh -c 'sync; echo 3 > /proc/sys/vm/drop_caches' 2>/dev/null
for ((i=0; i<6; i++)); do /usr/bin/date 2>&1; done

echo
echo ">>> Result: BEFORE = Input/output error, AFTER = timestamps  =>  the firewall"
echo ">>> starves the network-backed filesystem. (Firewall left OPEN for step 1c.)"
```

**Expected:** six `bash: /usr/bin/date: Input/output error` lines under BEFORE, then
six clean timestamps under AFTER. Same binary, same cold-cache condition; only the
firewall changed. (An `mmap`-heavy binary such as `llm 'hi'` shows `Bus error` / SIGBUS instead.)

> The loop uses bash builtins (`for (( ))`, no `seq` or `sleep`), so only the binary
> under test (`/usr/bin/date`) can fault; the script itself keeps running to the end.

> **If BEFORE prints timestamps too** (the binary was re-cached before it could be
> evicted), add real cache pressure and re-run the block:
> `( find /usr /opt /lib -type f 2>/dev/null | head -6000 | xargs -r -I{} cat {} >/dev/null 2>&1 ) &`

**Interpretation:** EIO under DROP, working the instant the firewall opens, is the decisive causal link: the firewall is starving a network-backed filesystem.

### 1c. Name the backend (firewall still open)

**[codespace]**
```bash
ss -tn | grep ESTAB | grep -vE '127\.0\.0|::1'
```

**Expected:** persistent `:443` connections to Azure ranges, e.g. `20.209.x`, `20.60.x`, `20.50.x`, `51.137.x` (Azure Storage service-tag space). One `:443` to `20.103.x` is the dev tunnel (already allowlisted), not storage.

```bash
# Optional: confirm these are Azure-owned (IPs derived automatically from the ss output above).
ss -tn | awk '/ESTAB/{print $5}' | sed -E 's/\[?::ffff://; s/\]//' \
  | awk -F: '$2==443{print $1}' | grep -vE '^(127|::1)' | sort -u \
  | while read -r ip; do echo "== $ip =="; whois "$ip" 2>/dev/null | grep -iE 'NetName|OrgName|Organization' | head -2; done
```

**Record the prefixes you observe.** Azure rotates them per instance, so yours may differ from the example. You will allow exactly these in Test 2.

---

## Test 2: Confirmation (slow, destructive): tie it to the stop-wedge

This ties the mechanism to the wedge and the data loss. It **will** wedge and likely destroy codespaces. Use throwaways.

### 2a. Control: firewall on, storage NOT allowed (expect a wedge)

On a fresh, firewall-active codespace (policy `DROP`, no storage allow):

**[local]**
```bash
date; gh codespace stop            # pick the instance
# poll until it reaches Shutdown, noting the clock:
date; gh codespace list            # repeat every minute or two
```

**Expected:** stays `ShuttingDown` well past ~5 minutes (historically 20 min to 4+ h). That is the wedge. (A resume afterwards may come back in recovery mode with an empty `/workspaces`, confirming the data-loss half.)

### 2b. Treatment: allow the observed storage ranges, then stop (non-deterministic)

On another fresh codespace, the block below re-derives the storage ranges, re-arms the firewall, and allows exactly those ranges (no manual editing needed):

**[codespace]**
```bash
# 1) Briefly open egress, provoke the storage backend, and capture its /16 ranges automatically:
sudo iptables -P OUTPUT ACCEPT; sudo iptables -F OUTPUT
( find /usr -type f 2>/dev/null | head -2000 | xargs -r -I{} cat {} >/dev/null 2>&1 ) &
sleep 6
RANGES=$(ss -tn | awk '/ESTAB/{print $5}' | sed -E 's/\[?::ffff://; s/\]//' \
  | awk -F: '$2==443{print $1}' | grep -vE '^(127|::1)' \
  | awk -F. '{print $1"."$2".0.0/16"}' | sort -u)
echo "storage ranges to allow: $RANGES"

# 2) Re-arm the firewall (setsid so a disconnect cannot interrupt it), then allow those ranges:
sudo --preserve-env=GITHUB_TOKEN setsid bash .devcontainer/init-firewall.sh > /tmp/fw.log 2>&1
sleep 60; sudo iptables -L OUTPUT -n | head -1     # confirm: policy DROP
REJ=$(sudo iptables -L OUTPUT --line-numbers -n | awk '/REJECT/{print $1; exit}')
for net in $RANGES; do
  sudo iptables -I OUTPUT "$REJ" -d "$net" -p tcp --dport 443 -j ACCEPT
done
sudo iptables -L OUTPUT -n | grep 443     # confirm the storage allows are present
```

**[local]**
```bash
date; gh codespace stop
date; gh codespace list            # poll until Shutdown
```

**Expected (non-deterministic):** the stop *may* reach `Shutdown` in ~2-3 minutes, but it may also still wedge. In a 2026-06-15 n=3 run, identical storage-only stops both wedged and completed cleanly. Allowing the observed ranges demonstrates the mechanism but is **not a dependable fix**: the stop can need rotating ranges you did not observe in step 1c. A clean stop resumes intact; a wedged one can destroy the workspace.

---

## Optional: see exactly what the firewall blocks (NFLOG)

Packets the firewall REJECTs **never appear in `tcpdump -i eth0`** (they die in `OUTPUT` before the capture tap). Use NFLOG instead:

**[codespace]**
```bash
REJ=$(sudo iptables -L OUTPUT --line-numbers -n | awk '/REJECT/{print $1; exit}')
sudo iptables -I OUTPUT "$REJ" -j NFLOG --nflog-group 5
sudo tcpdump -n -tttt -i nflog:5
```

**Expected:** a steady stream of rejected SYNs to Azure Storage `:443` ranges (plus wireserver `168.63.129.16:80` and IMDS `169.254.169.254:80`). This is the same instrument that originally surfaced the backend.

> Two practical caveats (2026-06-15): (1) `tcpdump` is usually **not preinstalled**; installing it needs a brief open-install-restore (`sudo bash -c 'iptables -P OUTPUT ACCEPT; iptables -F OUTPUT'; sudo apt-get update && sudo apt-get install -y tcpdump`, then re-run `init-firewall.sh`, ideally under `setsid`). (2) Capturing the rejects **during a stop** is unreliable: reconnecting to a firewall-active codespace (web editor *or* `gh codespace ssh`) tends to hang, so a live capture through the stop often cannot be observed. This connectivity catch-22 is why the exact stop-time endpoint set remains uncharacterised; see `issue-23-reproduction-results-2026-06-15.md`.

---

## Interpreting the results

| Observation | Conclusion |
|---|---|
| `date` EIO under DROP, works under ACCEPT (1a/1b) | Firewall is starving a network-backed filesystem. **Decisive.** |
| `ss -tn` shows persistent Azure `:443` connections (1c) | Names the backend (Azure Storage). |
| Firewall-on stop wedges; allowing storage *sometimes* clears it (2a/2b) | The wedge is the stop path unable to reach the blocked storage. **Corroborating, non-deterministic** (rotating ranges). |
| Allowing wireserver + IMDS does not reliably fix the wedge | Not the deciding factor (a storage-only stop also completed cleanly). |

Seeing EIO-under-DROP that clears under ACCEPT (Test 1) is the decisive reproduction of the root cause. The stop behaviour (Test 2) corroborates it but is non-deterministic, so do not treat a clean storage-allowed stop as required for a successful reproduction.

---

## Applicability: is this specific to safer-codespace?

Most likely **no**. The upstream firewall this template adapts
(`anthropics/claude-code` `.devcontainer/init-firewall.sh`) uses the same
default-DROP + final `REJECT` model and likewise does **not** allowlist the
Azure Storage backend a Codespace's filesystem rides on. Its allow-set (GitHub
meta ranges, a fixed domain list, the host `/24`, and `ESTABLISHED` connections)
does not cover the rotating `20.x`/`51.x` storage service-tag IPs, so the same
I/O-fault / stop-wedge class should affect the unmodified upstream when run in
GitHub Codespaces. The safer-codespace changes (IPv6 lockdown, dev-tunnel
allows, removed telemetry, restricted SSH, fail-closed) do not touch this path.

For the storage path the two scripts behave **identically**: neither allowlists the
backend, and their differences are all in other paths (dev tunnels, DNS/SSH breadth)
that do not touch storage `:443`. So the reproduction above is, for this bug, also a
reproduction of the upstream script's behaviour. A verbatim upstream run would only
change the picture if upstream incidentally allowed storage, which inspection rules
out. (Reads can look fine while the storage connection opened at container creation
survives via the `ESTABLISHED` rule; faults surface when a fresh connection is needed.)
Still worth reporting to `anthropics/claude-code`.

---

## Cleanup

**[local]**
```bash
gh codespace list
gh codespace delete -c <name> --force      # delete every throwaway you created
```

---

## Caveats (read before generalizing)

- **Rotating ranges.** Azure Storage IPs/prefixes rotate per instance, so any example ranges are illustrative. Always re-derive them with step 1c on *your* instance; a single prefix is usually **insufficient** because the stop can need ranges you never observed during normal use.
- **The storage-allow is not a fix.** In a 2026-06-15 n=3 run, identical storage-only stops both wedged and completed cleanly. Allowing observed ranges demonstrates the mechanism; it is not a stable allowlist.
- **Why this is a "won't-fix," not a patch.** Making storage reachable means allowing the Azure Storage **service tag for the whole region** (a large, attacker-usable egress surface). That contradicts the template's purpose. The repo's resolution is environmental: **run locally (Clone in Volume)**, where the filesystem is local and this failure class cannot occur. See issue #23.

---

## Appendix: reference outputs from the original investigation (2026-06-13)

**Storage-starvation A/B** (the core proof):
```
=== before (firewall DROP) ===
bash: /usr/bin/date: Input/output error
bash: /usr/bin/date: Input/output error
bash: /usr/bin/date: Input/output error
=== firewall now fully OPEN; retrying date ===
Sat Jun 13 12:50:21 PM UTC 2026
Sat Jun 13 12:50:23 PM UTC 2026
Sat Jun 13 12:50:25 PM UTC 2026
Sat Jun 13 12:50:27 PM UTC 2026
Sat Jun 13 12:50:29 PM UTC 2026
```

**Backend identification** (`ss -tn`, firewall open):
```
ESTAB  10.0.14.249:53884            20.209.72.161:443
ESTAB  10.0.14.249:47820            20.50.201.195:443
ESTAB  [::ffff:10.0.14.249]:46142   [::ffff:20.60.196.37]:443
ESTAB  [::ffff:10.0.14.249]:56570   [::ffff:51.137.3.17]:443
ESTAB  [::ffff:10.0.14.249]:33580   [::ffff:20.103.221.187]:443   # tunnel, already allowed
```

**A clean-stop example** (firewall on, four storage ranges allowed; later runs showed this outcome is non-deterministic):
```
stop issued 14:55:46  ->  Shutdown 14:58:26   =  2 minutes 40 seconds
(controls: 2-3 min firewall-off; wedges: 20 min to 4+ h firewall-on without storage)
```

**NFLOG capture** (what was rejected during a wedge, 2026-06-11):
```
... 10.0.10.247 > 168.63.129.16.80:   Flags [S]   # Azure wireserver
... 10.0.10.247 > 20.209.192.167.443: Flags [S]   # Azure Storage range (hammered)
... 10.0.10.247 > 169.254.169.254.80: Flags [S]   # IMDS
```
