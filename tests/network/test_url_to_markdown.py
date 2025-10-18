# /// script
# dependencies = [
#   "httpx",
#   "html2text",
#   "lxml",
#   "lxml_html_clean",
# ]
# ///

"""Test suite for url_to_markdown.py CLI tool.

This test suite validates:
1. Input validation (empty URLs, invalid formats, blocked domains)
2. Domain allow-list enforcement (one test URL per allowed domain)
3. Content fetching and conversion for real documentation sites

Following the project's testing philosophy: no pytest/unittest, just assertions
and immediate validation with clear output.
"""

import sys
from pathlib import Path

# Add cli-tools to path so we can import url_to_markdown
project_root = Path(__file__).parent.parent.parent
sys.path.insert(0, str(project_root / "cli-tools"))

from url_to_markdown import url_to_markdown, ALLOWED_DOMAINS


def test_validation_empty_url():
    """Test that empty URLs are rejected."""
    result = url_to_markdown("")
    assert "Error: URL cannot be empty" in result, f"Expected empty URL error, got: {result}"
    print("✓ Empty URL validation passed")


def test_validation_invalid_protocol():
    """Test that URLs without http/https are rejected."""
    result = url_to_markdown("ftp://example.com")
    assert "Error: URL must start with http" in result, f"Expected protocol error, got: {result}"
    print("✓ Invalid protocol validation passed")


def test_validation_blocked_domain():
    """Test that non-allowed domains are rejected."""
    result = url_to_markdown("https://malicious-site.com/page")
    assert "Error: Domain" in result and "not in the allow-list" in result, \
        f"Expected domain block error, got: {result}"
    print("✓ Blocked domain validation passed")


def test_validation_whitespace_handling():
    """Test that URLs with whitespace are handled correctly."""
    result = url_to_markdown("  https://malicious-site.com/page  ")
    assert "Error: Domain" in result, f"Expected domain error for whitespace URL, got: {result}"
    print("✓ Whitespace handling validation passed")


# Test cases: one example URL per allowed domain
# These are real documentation pages that should be accessible
DOMAIN_TEST_URLS = {
    # Python
    'docs.python.org': 'https://docs.python.org/3/library/pathlib.html',
    'pypi.org': 'https://pypi.org/project/httpx/',

    # JavaScript/Node
    'developer.mozilla.org': 'https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array',
    'docs.npmjs.com': 'https://docs.npmjs.com/cli/v10/commands/npm-install',
    'nodejs.org': 'https://nodejs.org/en/docs/guides/getting-started-guide',

    # Other languages
    'docs.oracle.com': 'https://docs.oracle.com/en/java/javase/17/docs/api/java.base/java/lang/String.html',
    'learn.microsoft.com': 'https://learn.microsoft.com/en-us/dotnet/csharp/tour-of-csharp/',

    # Frameworks & Tools
    'react.dev': 'https://react.dev/learn',
    'vuejs.org': 'https://vuejs.org/guide/introduction.html',
    'flask.palletsprojects.com': 'https://flask.palletsprojects.com/en/3.0.x/quickstart/',
    'docs.djangoproject.com': 'https://docs.djangoproject.com/en/5.0/intro/tutorial01/',

    # Version control & DevOps
    'docs.github.com': 'https://docs.github.com/en/get-started/quickstart/hello-world',
    'docs.gitlab.com': 'https://docs.gitlab.com/ee/user/project/',

    # Databases
    'postgresql.org': 'https://www.postgresql.org/docs/current/tutorial-start.html',
    'dev.mysql.com': 'https://dev.mysql.com/doc/refman/8.0/en/tutorial.html',
    'mongodb.com': 'https://www.mongodb.com/docs/manual/introduction/',

    # LLM/AI related
    'llm.datasette.io': 'https://llm.datasette.io/en/stable/',
    'datasette.io': 'https://datasette.io/tutorials/learn-sql',
    'platform.openai.com': 'https://platform.openai.com/docs/quickstart',
    'docs.claude.com': 'https://docs.claude.com/en/docs/intro',
    'ai.google.dev': 'https://ai.google.dev/gemini-api/docs',

    # Cloud providers
    'cloud.google.com': 'https://cloud.google.com/docs',
    'aws.amazon.com': 'https://aws.amazon.com/documentation/',
    'azure.microsoft.com': 'https://azure.microsoft.com/en-us/get-started/',
}


def test_domain_url(domain: str, url: str, verbose: bool = False) -> tuple[bool, str]:
    """Test fetching and converting a URL from a specific domain.

    Args:
        domain: The domain being tested.
        url: The full URL to fetch.
        verbose: If True, print detailed output.

    Returns:
        Tuple of (success: bool, message: str)
    """
    if verbose:
        print(f"\n  Testing {domain}...")
        print(f"  URL: {url}")

    result = url_to_markdown(url, timeout=10)

    # Check for success indicators
    success = "Successfully fetched and converted" in result

    if not success:
        # Check if it's a network error vs validation error
        if "Failed to fetch URL" in result or "timeout" in result.lower():
            return False, f"Network error (may be temporary): {result[:200]}"
        else:
            return False, f"Unexpected error: {result[:200]}"

    # Validate that file was created
    if "Saved to:" in result:
        # Extract file path from result
        lines = result.split('\n')
        file_path_line = [line for line in lines if 'Saved to:' in line]
        if file_path_line:
            file_path_str = file_path_line[0].replace('Saved to:', '').strip()
            file_path = Path(file_path_str)

            if not file_path.exists():
                return False, f"File reported as saved but not found: {file_path}"

            # Check file has content
            content_size = file_path.stat().st_size
            if content_size < 100:
                return False, f"File too small ({content_size} bytes), may be empty"

            if verbose:
                print(f"  ✓ File saved: {file_path.name} ({content_size:,} bytes)")

    return True, "Success"


def test_all_allowed_domains(verbose: bool = False, skip_on_network_error: bool = True):
    """Test fetching one URL from each allowed domain.

    Args:
        verbose: If True, print detailed output for each test.
        skip_on_network_error: If True, skip domains with network errors instead of failing.
    """
    print("\n" + "=" * 70)
    print("Testing URL fetching for all allowed domains")
    print("=" * 70)

    total_domains = len(ALLOWED_DOMAINS)
    tested_domains = len(DOMAIN_TEST_URLS)
    passed = 0
    failed = 0
    skipped = 0
    errors = []

    print(f"\nTotal allowed domains: {total_domains}")
    print(f"Domains with test URLs: {tested_domains}")

    # Find domains without test URLs
    untested_domains = ALLOWED_DOMAINS - set(DOMAIN_TEST_URLS.keys())
    if untested_domains:
        print(f"\n⚠️  Warning: {len(untested_domains)} domains lack test URLs:")
        for domain in sorted(untested_domains):
            print(f"  - {domain}")

    print(f"\nRunning tests for {tested_domains} domains...\n")

    for domain, url in sorted(DOMAIN_TEST_URLS.items()):
        success, message = test_domain_url(domain, url, verbose=verbose)

        if success:
            passed += 1
            if not verbose:
                print(f"✓ {domain}")
        else:
            if "Network error" in message and skip_on_network_error:
                skipped += 1
                print(f"⊘ {domain} - SKIPPED (network issue)")
                if verbose:
                    print(f"  {message}")
            else:
                failed += 1
                print(f"✗ {domain} - FAILED")
                print(f"  {message}")
                errors.append(f"{domain}: {message}")

    # Print summary
    print("\n" + "=" * 70)
    print("Test Summary")
    print("=" * 70)
    print(f"Passed:  {passed}/{tested_domains}")
    print(f"Failed:  {failed}/{tested_domains}")
    print(f"Skipped: {skipped}/{tested_domains} (network errors)")

    if errors:
        print("\nFailures:")
        for error in errors:
            print(f"  - {error}")

    # Assertion: all tested domains should pass (or be skipped due to network)
    if failed > 0:
        raise AssertionError(f"{failed} domain tests failed (see details above)")

    print("\n✓ All domain tests passed!")


def run_all_tests(verbose: bool = False):
    """Run all test suites.

    Args:
        verbose: If True, print detailed output.
    """
    print("=" * 70)
    print("URL to Markdown - Test Suite")
    print("=" * 70)

    # Run validation tests
    print("\nValidation Tests")
    print("-" * 70)
    test_validation_empty_url()
    test_validation_invalid_protocol()
    test_validation_blocked_domain()
    test_validation_whitespace_handling()
    print("\n✓ All validation tests passed!")

    # Run domain tests
    test_all_allowed_domains(verbose=verbose, skip_on_network_error=True)

    print("\n" + "=" * 70)
    print("✓ ALL TESTS PASSED!")
    print("=" * 70)


if __name__ == "__main__":
    # Parse command line arguments
    verbose = "--verbose" in sys.argv or "-v" in sys.argv

    try:
        run_all_tests(verbose=verbose)
    except AssertionError as error:
        print(f"\n✗ TEST SUITE FAILED: {error}")
        sys.exit(1)
    except Exception as error:
        print(f"\n✗ UNEXPECTED ERROR: {error}")
        import traceback
        traceback.print_exc()
        sys.exit(1)
