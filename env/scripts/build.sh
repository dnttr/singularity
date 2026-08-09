#!/bin/bash

# Note: We gotta remove the binary before actually copying 'singularity-runtime' to the target location, as otherwise
# the operation will fail due to the binary being locked.

RESTART_COLOR="\e[0m"

LIGHT_GRAY="\e[0;37m"

BOLD_GREEN="\e[1;92m"
BOLD_DARK_GREEN="\e[1;32m"

LONG_MARKER="${LIGHT_GRAY}--->${RESTART_COLOR}"
SHORT_MARKER="${LIGHT_GRAY}>${RESTART_COLOR}"

set -e

echo "${LONG_MARKER} ${BOLD_GREEN} Running 'build' task. ${RESTART_COLOR}"

echo "Building..."
limactl shell --workdir "$PWD" singularity env CARGO_TARGET_DIR="/tmp/singularity-target" cargo build -p singularity-runtime --release
echo "${SHORT_MARKER} ${BOLD_DARK_GREEN}Successfully${RESTART_COLOR} built singularity-runtime."

echo "Preparing for deployment..."
limactl shell singularity sudo rm -f /usr/bin/singularity-runtime
echo "${SHORT_MARKER} ${BOLD_DARK_GREEN}Successfully${RESTART_COLOR} prepared for deployment."

echo "Deploying binary..."
limactl shell singularity sudo cp /tmp/singularity-target/release/singularity-runtime /usr/bin/
echo "${SHORT_MARKER} ${BOLD_DARK_GREEN}Successfully${RESTART_COLOR} deployed binary."

echo "Deploying service..."
limactl shell --workdir "$PWD" singularity sudo cp src/runtime/singularity-runtime.service /etc/systemd/system/
echo "${SHORT_MARKER} ${BOLD_DARK_GREEN}Successfully${RESTART_COLOR} deployed service."

echo "${LONG_MARKER} ${BOLD_GREEN}Finished the task.${RESTART_COLOR}"
