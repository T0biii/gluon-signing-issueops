#!/bin/sh

set -e

if [ $# -ne 2 -o "-h" = "$1" -o "--help" = "$1" -o -z "$1" -o ! -r "$2" ]; then
        cat <<EOHELP
Usage: $0 <secret_env_var> <manifest>

sign.sh adds lines to a manifest to indicate the approval
of the integrity of the firmware as required for automated
updates. The first argument <secret_env_var> is the name of an environment variable
containing the private key as string (not as file!).
The script may be performed multiple times to the same document
to indicate an approval by multiple developers.

See also
 * ecdsautils on https://github.com/tcatm/ecdsautils

EOHELP
        exit 1
fi

SECRET_ENV_VAR="$1"
manifest="$2"
upper="$(mktemp)"
lower="$(mktemp)"

trap 'rm -f "$upper" "$lower"' EXIT

awk 'BEGIN    { sep=0 }
     /^---$/ { sep=1; next }
              { if(sep==0) print > "'"$upper"'";
                else       print > "'"$lower"'"}' \
    "$manifest"

SECRET=$(printenv "$SECRET_ENV_VAR")
if [ -z "$SECRET" ]; then
    echo "Secret not found in environment variable $SECRET_ENV_VAR" >&2
    exit 2
fi

signature=$(ecdsasign "$upper" <<<$SECRET)

(
        cat "$upper"
        echo ---
        cat "$lower"
        echo "$signature"
) > "$manifest"

echo "$signature"
