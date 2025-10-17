# CLI Tools - TODO

This directory contains standalone uv scripts for fetching and processing web content.

## Current Tools

### url_to_markdown.py
Fetches HTML content from **ALLOW-LISTED DOCUMENTATION SITES ONLY** and converts it to markdown, saving to `context/untrusted/`.

**Status:** ✅ Implemented with security hardening

**Security Features:**
- ✅ Domain allow-list (only trusted documentation sites)
- ✅ Content-type validation (HTML only, blocks PDFs/images)
- ✅ Aggressive HTML cleaning (removes scripts, iframes, forms)
- ✅ Security warnings in output markdown
- ✅ Defense-in-depth (works with or without firewall)

**Usage:**
```bash
# Direct execution with uv (recommended)
uv run cli-tools/url_to_markdown.py https://docs.python.org/3/

# uv automatically manages dependencies from script metadata
```

**Allowed Domains:**
See `ALLOWED_DOMAINS` in the script. Includes:
- Python: docs.python.org, pypi.org, readthedocs.io
- JavaScript: developer.mozilla.org, nodejs.org
- Rust: docs.rs, doc.rust-lang.org
- Go: golang.org, go.dev
- LLM/AI: llm.datasette.io, docs.anthropic.com, platform.openai.com
- And more...

## Security Rationale

Based on Simon Willison's research on **prompt injection** and the **lethal trifecta**:

### Why Domain Allow-List?
Web pages can contain malicious instructions that LLMs will follow. By restricting to documentation sites, we reduce (but don't eliminate) the risk of:
- Instructions embedded in content
- Markdown exfiltration attacks
- Data theft via prompt injection

**References:**
- https://simonwillison.net/2025/Jun/16/the-lethal-trifecta/
- https://simonwillison.net/2022/Sep/12/prompt-injection/

### Why No PDFs/Images?
- Binary files can contain embedded malicious content
- Images can use data URIs for exfiltration
- PDFs often contain JavaScript
- HTML-only keeps attack surface minimal

### Why Aggressive HTML Cleaning?
- Removes `<script>` tags that could contain instructions
- Removes `<iframe>` tags that could load external content
- Removes `<form>` tags that could submit data
- Strips inline styles that could hide content

### Defense in Depth
This tool implements application-level security **in addition to** the devcontainer firewall:
- Firewall = outer layer (infrastructure)
- Allow-list = inner layer (application)
- Both layers protect independently

## Planned Enhancements

### url_to_markdown.py Improvements
- [ ] Add retry logic for failed requests
- [ ] Support for custom output directory
- [ ] Add verbose/debug mode
- [ ] Extract and display page `<title>` in output message
- ~~[ ] Add HTML cleaning~~ ✅ Completed
- ~~[ ] Domain allow-list~~ ✅ Completed
- ~~[ ] Content-type validation~~ ✅ Completed

### Future Tools
- [ ] `validate_markdown` - Check markdown files for potential prompt injection
- [ ] `extract_code_blocks` - Extract only code blocks from markdown (safest content)
- [ ] `list_allowed_domains` - CLI tool to list/search allowed domains

## Testing Checklist

### url_to_markdown.py Security Tests
- [x] Test with allowed domain (docs.python.org) ✅
- [x] Test with disallowed domain (www.example.com) ✅ - blocked correctly
- [ ] Test with PDF URL (should fail with content-type error)
- [ ] Test with image URL (should fail with content-type error)
- [ ] Verify HTML cleaning removes scripts
- [x] Verify security warnings appear in output ✅
- [x] Verify file is saved to context/untrusted/ ✅

### url_to_markdown.py Functional Tests
- [ ] Test with invalid URL
- [ ] Test with timeout scenario
- [ ] Test with redirects
- [ ] Verify filename sanitization works correctly
- [ ] Check markdown conversion quality

## Out of Scope

These features are **intentionally not supported** for security reasons:

- ❌ Fetching from arbitrary domains (prompt injection risk)
- ❌ Processing PDF files (binary format, JavaScript risk)
- ❌ Processing images (data URI exfiltration risk)
- ❌ Complex JavaScript site rendering (attack surface too large)
- ❌ Automatic authentication (credential exposure risk)

## Notes

- All fetched content is saved to `context/untrusted/` for security
- Even content from allow-listed domains should be treated as untrusted
- Dependencies are managed via uv script metadata (PEP 723)
- Error messages are descriptive and explain security rationale
