#!/bin/bash
#
# Prints a non-reversible fingerprint of a secret so a local value can be
# compared with a GitHub Actions secret without either being revealed.
#
# Local usage (prompts without echoing, so the value stays out of shell history):
#   Scripts/fingerprint-secret.sh
#
# Or pipe the value in (piped bytes are fingerprinted exactly, including any
# trailing newline):
#   pbpaste | Scripts/fingerprint-secret.sh
#
# The CI side is the "Check Secret" workflow, which runs this same script
# against the stored secret. Matching output means the values are identical.

set -euo pipefail

if [[ -t 0 ]]; then
    printf 'Secret value (input hidden): ' >&2
    IFS= read -rs value
    printf '\n' >&2
else
    # The sentinel stops command substitution stripping trailing newlines,
    # which are exactly the kind of difference this script needs to catch.
    value="$(
        cat
        printf x
    )"
    value="${value%x}"
fi

if command -v shasum >/dev/null 2>&1; then
    sha256() { shasum -a 256; }
else
    sha256() { sha256sum; }
fi

if [[ -z "$value" ]]; then
    echo "Fingerprint: <empty> (the secret is blank or does not exist)"
    exit 0
fi

# 12 hex characters is plenty to spot a mismatch while revealing very little.
fingerprint="$(printf '%s' "$value" | sha256 | cut -c1-12)"
byte_count="$(printf '%s' "$value" | wc -c | tr -d ' ')"

echo "Fingerprint: $fingerprint"
echo "Length:      $byte_count bytes"

# Formatting problems that silently break a key once it reaches the build.
[[ "$value" =~ ^[[:space:]] ]] && echo "Warning:     leading whitespace"
[[ "$value" =~ [[:space:]]$ ]] && echo "Warning:     trailing whitespace or newline"
[[ "$value" == *$'\n'* ]] && echo "Warning:     contains a newline"
[[ "$value" == \"*\" || "$value" == \'*\' ]] && echo "Warning:     wrapped in quotes"
[[ "$value" == *//* ]] && echo "Warning:     contains '//' (xcconfig treats the rest as a comment)"

exit 0
