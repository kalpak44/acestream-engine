#!/usr/bin/env bash

# Create required cache directories in /dev/shm
mkdir -p /dev/shm/.ACEStream /dev/shm/acecache

exec \
	/app/start-engine \
	--client-console \
	"$@"