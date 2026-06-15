# Issue #23: independent reproduction results (2026-06-15)

Independent run of the minimal reproducible example
(`issue-23-minimal-reproduction.md`) on fresh GitHub Codespaces created from
`nicomarr/safer-codespace` `main`. Goal: confirm the stop-wedge / I/O-fault root
cause from scratch rather than relying on the original 2026-06-10..13
investigation.

## Summary

- **Root-cause mechanism: reproduced decisively.** With the firewall active,
  filesystem reads to uncached pages fail; opening the firewall fixes them
  instantly. The container filesystem is Azure-Storage-backed over the network.
- **Stop-wedge: reproduced.** A firewall-active stop sat in `ShuttingDown` for
  10+ minutes.
- **The storage-allow "fix": shown to be non-deterministic (n=3).** Allowing the
  storage ranges observed during normal operation sometimes yielded a clean stop
  and sometimes still wedged. This independently supports the repo's won't-fix /
  run-locally decision: allowlisting observed ranges is not a reliable fix.
- **Not captured: the exact endpoint set a wedged stop needs.** Blocked by a
  structural catch-22 (below), not by lack of trying.

## Environment

- Repo `nicomarr/safer-codespace`, branch `main` (post PRs #21..#38).
- 2-core / 8 GB / 32 GB Codespaces, created with `gh codespace create`.
- All firewall checks/edits in the Codespace; all `gh codespace` stop/timing
  commands from a local Mac terminal.

## Results

| Instance | Allow-set on the stop | Stop outcome |
|---|---|---|
| organic-goggles | storage only: `20.50`, `20.209`, `51.137` (`:443`) | **WEDGE**, 10+ min (`ShuttingDown` 10:28:10 -> still stuck 10:38:20) |
| scaling-fishstick | storage (`20.103/20.209/20.42/20.60/51.137`) + wireserver `168.63.129.16:80` + IMDS `169.254.169.254:80` | clean, ~2.5 min (10:52:44 -> Shutdown by ~10:55) |
| probable-giggle | storage only: `51.137`, `20.209`, `20.103` (`:443`) | clean, ~3-4 min |

Storage ranges rotated on every instance, exactly as the MRE warns.

## What reproduced reliably

**The mechanism (Test 1), on organic-goggles.** Same binary, same cold-cache
condition, only the firewall changed:

```
=== BEFORE: firewall active (policy DROP) ===
bash: /usr/bin/date: Input/output error      (x8)
=== AFTER: firewall opened (OUTPUT ACCEPT + flush) ===
Mon Jun 15 08:17:02 AM UTC 2026               (x6, all clean)
```

**The backend (Test 1c).** With the firewall open, persistent `:443`
connections to Azure Storage ranges, e.g. on organic-goggles:

```
ESTAB  10.0.2.137:52690  -> 20.50.201.204:443
ESTAB  10.0.2.137:33946  -> 20.209.77.197:443
ESTAB  10.0.2.137:38838  -> 51.137.3.17:443
        (plus tunnel 20.103.221.187:443, IMDS 169.254.169.254:80)
```

**The wedge.** organic-goggles, firewall active, storage-only allow-set: 10+
minutes in `ShuttingDown`.

## The non-determinism finding (the new result)

The two storage-only stops split: organic-goggles **wedged**, probable-giggle
**stopped cleanly**. wireserver/IMDS were not decisive either (probable-giggle
had neither and was clean; organic-goggles had neither and wedged). The most
likely explanation is that the stop-flush needs specific Azure Storage ranges
that **rotate**, and whether they happen to fall inside the allowed set varies
per instance and per stop.

Consequence: allowlisting the ranges seen during normal operation is **not a
reliable fix** for the stop-wedge. This is the empirical basis (n=3) for the
repo's decision in issue #23 not to allowlist the storage backend and to treat
local Docker as the supported secure path.

## What could not be captured, and why

The remaining open question is the exact endpoint set a *wedged* stop tries to
reach. Capturing it requires NFLOG (REJECTed packets never reach `eth0`) plus a
live connection that survives the stop. We could not get a clean capture because
of a structural catch-22:

- To observe the wedge, the box must stay reachable during the stop.
- Reaching a firewall-active box needs a fresh tunnel connection; both the web
  editor reconnect and `gh codespace ssh` **hung** against the active firewall
  (the box stayed `Available`, i.e. armed but unreachable). This is the same
  connectivity behaviour the original investigation documented.
- A wedged stop also destroys the container, so on-disk capture does not survive.

So the observation channel is the very thing the firewall disrupts. This is the
wall the original investigation named; today's run hit it again.

## Operational note: the SIGHUP brick (corroborates #22)

Re-arming the firewall interactively (not detached) disconnected the editor
mid-apply, killing the shell before the storage-allow rules were added. The box
was left at `policy DROP` with no storage allowed, the filesystem starved, and
the session could not reconnect. Running the whole setup detached
(`setsid bash ...`) avoided it. This corroborates issue #22's fail-closed/SIGHUP
concern and the MRE's `setsid` guidance.

## Applicability (likely upstream, not safer-codespace-specific)

By code inspection, the upstream `anthropics/claude-code`
`.devcontainer/init-firewall.sh` (which this template adapts) shares the same gap:
default-DROP + `REJECT`, with an allow-set (GitHub ranges, fixed domain list, host
`/24`, `ESTABLISHED`) that does not cover the Azure Storage backend. For the storage
path the two scripts are identical (their differences live in other paths that do not
touch storage `:443`), so the `date` EIO A/B above effectively reproduces the upstream
script's storage behaviour. A verbatim upstream run would only differ if upstream
incidentally allowed storage, which inspection rules out. Worth reporting to
`anthropics/claude-code`.

Separate observation (NOT this bug, recorded so the two are not conflated): on a
2026-06-15 instance, `claude --version` crashed (`Bus error` / `Illegal instruction`,
Bun 1.3.14 "baseline" build) under **both** a closed and an open firewall. Because it
persisted with the firewall open, it is firewall-independent and is most likely a Bun
build/CPU issue, not the storage starvation.

## Bottom line

The root cause in issue #23 is independently confirmed on current `main`: the
default-DROP firewall starves the Codespaces network-backed (Azure Storage)
filesystem, causing I/O faults and the stop-wedge. The storage-allow workaround
is non-deterministic and therefore not a viable fix, which strengthens the
existing won't-fix / run-locally decision. The only piece that remains
uncharacterised, the precise stop-time endpoint set, is unobservable from inside
the guest by the issue's own nature.
