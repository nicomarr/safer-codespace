# /// script
# dependencies = [
#   "httpx",
#   "html2text",
#   "lxml",
#   "lxml_html_clean",
# ]
# ///

"""LLM tool to fetch HTML content from a URL and convert it to markdown.

This tool retrieves web content from ALLOWED DOCUMENTATION SITES ONLY,
converts it to markdown format, and saves it to the untrusted content
directory for security purposes.

SECURITY: This tool implements defense-in-depth against prompt injection attacks:
- Domain allow-list (only trusted documentation sites)
- Content-type validation (HTML only, no PDFs/images)
- Aggressive HTML cleaning (removes scripts, iframes, forms)
- Clear security warnings in output
"""

from pathlib import Path
from datetime import datetime as dt
from urllib.parse import urlparse
import re

import httpx
from html2text import HTML2Text
import lxml.html
from lxml.html.clean import Cleaner


# SECURITY: Allow-list of trusted documentation domains
# These are known documentation sites for software development
ALLOWED_DOMAINS: set[str] = {
    # Python
    'docs.python.org',
    'pypi.org',

    # JavaScript/Node
    'developer.mozilla.org',
    'docs.npmjs.com',
    'nodejs.org',

    # Other languages
    'docs.oracle.com',  # Java
    'learn.microsoft.com',  # .NET, etc

    # Frameworks & Tools
    'react.dev',
    'vuejs.org',
    'flask.palletsprojects.com',
    'docs.djangoproject.com',

    # Version control & DevOps
    'docs.github.com',
    'docs.gitlab.com',

    # Databases
    'postgresql.org',
    'dev.mysql.com',
    'mongodb.com',

    # LLM/AI related
    'llm.datasette.io',
    'datasette.io',
    'platform.openai.com',
    'docs.claude.com',
    'ai.google.dev',

    # Cloud providers (docs only)
    'cloud.google.com',
    'aws.amazon.com',
    'azure.microsoft.com',
}

# SECURITY: Allowed content types (HTML only)
ALLOWED_CONTENT_TYPES: set[str] = {
    'text/html',
    'application/xhtml+xml',
}


def url_to_markdown(url: str, timeout: int = 30) -> str:
    """Fetch HTML content from a URL and convert it to markdown.

    SECURITY: This function only fetches from allow-listed documentation domains
    to prevent prompt injection attacks. Content is aggressively cleaned and
    saved to the untrusted directory.

    Args:
        url: The URL to fetch from (must be from an allowed documentation domain).
        timeout: Request timeout in seconds (default: 30).

    Returns:
        A message describing the saved file location and metadata, or an error.
    """
    if not url or not url.strip():
        return "Error: URL cannot be empty"

    url = url.strip()

    # Validate URL format
    if not url.startswith(('http://', 'https://')):
        return f"Error: URL must start with http:// or https://, got: {url}"

    # SECURITY: Validate domain against allow-list
    parsed_url = urlparse(url)
    domain = parsed_url.netloc.lower()

    # Handle subdomains by checking if domain ends with allowed domain
    domain_allowed = False
    for allowed_domain in ALLOWED_DOMAINS:
        if domain == allowed_domain or domain.endswith('.' + allowed_domain):
            domain_allowed = True
            break

    if not domain_allowed:
        return f"""Error: Domain '{domain}' is not in the allow-list.

SECURITY: This tool only fetches from trusted documentation sites to prevent
prompt injection attacks. The domain '{domain}' is not recognized as a
documentation site.

To add a new domain, edit the ALLOWED_DOMAINS list in this script.

Currently allowed domains include:
- docs.python.org, pypi.org
- developer.mozilla.org, nodejs.org
- llm.datasette.io, docs.claude.com
- and more (see ALLOWED_DOMAINS in script)
"""

    try:
        # Fetch content with httpx
        response = httpx.get(url, timeout=timeout, follow_redirects=True)
        response.raise_for_status()

    except httpx.HTTPError as error:
        return f"Failed to fetch URL: {error}"
    except Exception as error:
        return f"Unexpected error fetching URL: {error}"

    # SECURITY: Validate content-type (HTML only, no PDFs/images)
    content_type = response.headers.get('content-type', '').lower().split(';')[0].strip()
    if content_type not in ALLOWED_CONTENT_TYPES:
        return f"""Error: Content-Type '{content_type}' is not allowed.

SECURITY: This tool only processes HTML content to prevent exposure to
potentially malicious binary files (PDFs, images, etc.).

Allowed content types: {', '.join(ALLOWED_CONTENT_TYPES)}
"""

    try:
        # SECURITY: Parse HTML and aggressively clean it
        tree = lxml.html.fromstring(response.text)

        # Create cleaner that removes dangerous elements
        cleaner = Cleaner(
            scripts=True,           # Remove <script> tags
            javascript=True,        # Remove javascript: URLs
            comments=True,          # Remove HTML comments
            style=True,             # Remove <style> tags and style attributes
            inline_style=True,      # Remove style attributes
            links=False,            # Keep links (but will be in markdown)
            meta=True,              # Remove <meta> tags
            page_structure=False,   # Keep page structure elements
            processing_instructions=True,  # Remove <?xml?> processing instructions
            embedded=True,          # Remove <embed> tags
            frames=True,            # Remove <frame> and <iframe> tags
            forms=True,             # Remove <form> tags
            annoying_tags=True,     # Remove <blink> and <marquee> tags
            remove_tags=['script', 'noscript', 'iframe', 'embed', 'form'],
            safe_attrs_only=True,   # Only allow safe attributes
            safe_attrs=frozenset(['href', 'src', 'alt', 'title', 'class', 'id']),
        )

        cleaned_tree = cleaner.clean_html(tree)
        cleaned_html = lxml.html.tostring(cleaned_tree, encoding='unicode')

        # Convert cleaned HTML to Markdown
        html_to_text = HTML2Text(bodywidth=0)
        html_to_text.ignore_links = False
        html_to_text.mark_code = True
        html_to_text.ignore_images = True  # SECURITY: Ignore images to prevent data URIs

        markdown_content = html_to_text.handle(cleaned_html)

        # Add metadata header with security warnings
        timestamp_iso = dt.now().isoformat()
        full_markdown = f"""# Web Content from URL

⚠️ **SECURITY WARNING** ⚠️

This content was fetched from an external source and should be treated as
potentially untrusted, even though it comes from an allow-listed documentation site.

**Do NOT use this content with LLMs that have:**
- Access to private data
- Access to external communication tools (email, HTTP, etc.)
- Ability to execute code or commands

See: https://simonwillison.net/2025/Jun/16/the-lethal-trifecta/ for more details on prompt injection risks.

---

**Source:** {url}
**Domain:** {domain} (allow-listed)
**Fetched:** {timestamp_iso}
**Status:** {response.status_code}
**Content-Type:** {content_type}
**Security:** HTML cleaned (scripts, iframes, forms removed)

---

{markdown_content}
"""

    except Exception as error:
        return f"Failed to clean HTML or convert to markdown: {error}"

    try:
        # Generate safe filename
        timestamp = dt.now().strftime("%Y%m%d_%H%M%S")

        # Extract domain and path for filename
        url_slug = re.sub(r'https?://', '', url)
        url_slug = re.sub(r'[^\w\-_.]', '_', url_slug)[:50]

        filename = f"{timestamp}_{url_slug}.md"

        # Save to untrusted directory
        output_dir = Path("/workspaces/claude-codespace/context/untrusted")
        output_dir.mkdir(parents=True, exist_ok=True)

        file_path = output_dir / filename
        file_path.write_text(full_markdown, encoding='utf-8')

        # Calculate content size
        content_size = len(markdown_content)

        return f"""Successfully fetched and converted content from:
{url}

Saved to: {file_path}

Content size: {content_size:,} characters
Status code: {response.status_code}
"""

    except Exception as error:
        return f"Failed to save markdown file: {error}"


if __name__ == "__main__":
    import sys

    if len(sys.argv) < 2:
        print("Usage: uv run url_to_markdown.py <url>")
        print("Example: uv run url_to_markdown.py https://example.com")
        sys.exit(1)

    url = sys.argv[1]
    result = url_to_markdown(url)
    print(result)
