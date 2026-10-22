#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/../infra" || exit 1

terraform destroy -auto-approve

DATE_STR=$(date "+%Y-%m-%d %H:%M:%S")
echo "| $DATE_STR | terraform destroy | OK - 0 ressource restante |" >> "$SCRIPT_DIR/../docs/journal-destructions.md"

echo -e "\nDestruction terminee avec succes"
