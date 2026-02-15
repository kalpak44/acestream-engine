#!/usr/bin/env bash
set -euo pipefail

mkdir -p /dev/shm/.ACEStream

exec /app/start-engine --client-console "$@"