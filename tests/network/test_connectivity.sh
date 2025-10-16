 #!/bin/bash
 # Network connectivity test for Claude Codespace dependencies
 # Following TDD principles - establish baseline before firewall implementation

 echo "=== Claude Codespace Network Connectivity Test ==="
 echo "Testing endpoints required by postCreateCommand tools..."
 echo

 # Core endpoints from your devcontainer.json postCreateCommand
 endpoints=(
     "PyPI (pip/uv):https://pypi.org/simple/"
     "GitHub API:https://api.github.com"
     "GitHub Models:https://models.inference.ai.azure.com"
     "Anthropic API:https://api.anthropic.com"
     "Gemini API:https://generativelanguage.googleapis.com"
     "npm registry:https://registry.npmjs.org"
     "Go modules:https://proxy.golang.org"
 )

 # Test each endpoint
 for endpoint in "${endpoints[@]}"; do
     name="${endpoint%%:*}"
     url="${endpoint#*:}"

     printf "Testing %-25s " "$name:"
     if curl -s --connect-timeout 5 --max-time 10 "$url" > /dev/null 2>&1; then
         echo "CONNECTED - TEST PASSED"
     else
         echo "NOT REACHABLE - TEST FAILED"
     fi
 done

 # Test additional endpoints that should not be reachable based on firewall rules, e.g www.example.com
    echo "Testing endpoints that should NOT be reachable..."
    unreachable_endpoints=(
        "Example Domain:http://www.example.com"
    )

    for endpoint in "${unreachable_endpoints[@]}"; do
        name="${endpoint%%:*}"
        url="${endpoint#*:}"

        printf "Testing %-25s " "$name:"
        if curl -s --connect-timeout 5 --max-time 10 "$url" > /dev/null 2>&1; then
            echo "CONNECTED (unexpected) - TEST FAILED"
        else
            echo "NOT REACHABLE (expected) - TEST PASSED"
        fi
    done
