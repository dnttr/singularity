#!/bin/bash

RESTART_COLOR="\e[0m"

LIGHT_GRAY="\e[0;37m"

BOLD_GREEN="\e[1;92m"
BOLD_DARK_GREEN="\e[1;32m"

LONG_MARKER="${LIGHT_GRAY}--->${RESTART_COLOR}"
SHORT_MARKER="${LIGHT_GRAY}>${RESTART_COLOR}"

set -e

echo "${LONG_MARKER} ${BOLD_GREEN} Running 'restart' task. ${RESTART_COLOR}"

echo "${SHORT_MARKER} Reloading daemon..."
limactl shell singularity sudo systemctl daemon-reload
echo "${SHORT_MARKER} ${BOLD_DARK_GREEN}Successfully${RESTART_COLOR} reloaded daemon."

echo "${SHORT_MARKER} Restarting service..."
limactl shell singularity sudo systemctl restart singularity-runtime.service
echo "${SHORT_MARKER} ${BOLD_DARK_GREEN}Successfully${RESTART_COLOR} restarted service."

echo "${SHORT_MARKER} Fetching the status..."
limactl shell singularity sudo systemctl status singularity-runtime.service --no-pager
echo "${SHORT_MARKER} ${BOLD_DARK_GREEN}Successfully${RESTART_COLOR} fetched the status."

echo "${LONG_MARKER} ${BOLD_GREEN}Finished the task.${RESTART_COLOR}"