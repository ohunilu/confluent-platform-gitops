#!/bin/bash
set -euo pipefail

# Download the Dynatrace ActiveGate installer from the Deployment API
wget -O /tmp/dynatrace-activegate.sh \
  "${DYNATRACE_ENV_URL}/api/v1/deployment/installer/gateway/unix/latest?arch=x86" \
  --header="Authorization: Api-Token ${DYNATRACE_PAAS_TOKEN}"

# Run the installer silently
sudo /bin/bash /tmp/dynatrace-activegate.sh