#!/bin/bash
set -euo pipefail
VM="chezmoi-test"
SNAPSHOT="chezmoi-test-4"
PROTON_PAT_NAME="chezmoi-test-pat-$(date +%s)"

# if hostname is not tobi-ubuntu, skip the test
if [[ "$(hostname)" != "tobi-ubuntu" ]]; then
  echo "Skipping test: hostname is not tobi-ubuntu. I am sorry boss"
  exit 1
fi

# Shutdown
VBoxManage controlvm "$VM" acpipowerbutton || true
while VBoxManage showvminfo "$VM" | grep -q "running"; do sleep 1; done

# Restore & start
VBoxManage snapshot "$VM" restore "$SNAPSHOT"
VBoxManage startvm "$VM" --type headless

# Wait for SSH
until ssh -q -o ConnectTimeout=2 -o StrictHostKeyChecking=no chezmoi-test exit 2>/dev/null; do
  echo "Waiting for SSH..."
  sleep 2
done

PROTON_PASS_PAT_JSON=$(pass-cli pat create --name "$PROTON_PAT_NAME" --expiration 1d --output json)
PROTON_PASS_PAT=$(echo "$PROTON_PASS_PAT_JSON" | jq -r '.env_var')
PROTON_PASS_PAT_ID=$(echo "$PROTON_PASS_PAT_JSON" | jq -r '.pat_id')
trap 'pass-cli pat delete --personal-access-token-id "$PROTON_PASS_PAT_ID"' EXIT
pass-cli pat access grant --personal-access-token-name "$PROTON_PAT_NAME" --vault-name "Personal"

ssh chezmoi-test "rm -rf ~/.local/share/chezmoi && PROTON_PASS_PERSONAL_ACCESS_TOKEN=$PROTON_PASS_PAT DEBUG=1 ~/.local/bin/chezmoi init twobiers --apply"
