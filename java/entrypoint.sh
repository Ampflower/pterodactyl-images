#!/bin/bash
export TZ=${TZ:-UTC}
export INTERNAL_IP="$(ip route get 1 | awk '{print $(NF-2);exit}')"
cd /home/container || (echo "Failed to change directory, missing /home/container or user?" && exit 1)

echo "Entered container."

echo "Printing Java..."
java -version

MODIFIED_STARTUP=$(eval echo "$(echo "${STARTUP}" | sed -e 's/{{/${/g' -e 's/}}/}/g')")
echo "Entering ${MODIFIED_STARTUP}"

# shellcheck disable=SC2086
exec env $MODIFIED_STARTUP
