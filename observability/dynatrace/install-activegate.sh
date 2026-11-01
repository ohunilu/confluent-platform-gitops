#!/bin/bash
set -euo pipefail

# Ensure wget is present
if ! command -v wget >/dev/null 2>&1; then
  apt-get update
  apt-get install -y wget
fi

# Download the Dynatrace ActiveGate installer from the Deployment API
wget -O /tmp/dynatrace-activegate.sh \
  "${DYNATRACE_ENV_URL}/api/v1/deployment/installer/gateway/unix/latest?arch=x86" \
  --header="Authorization: Api-Token ${DYNATRACE_PAAS_TOKEN}"

# Run the installer silently (CustomScript extension runs as root)
sudo /bin/bash /tmp/dynatrace-activegate.sh