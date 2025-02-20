#!/bin/bash

cd $NEXUS_HOME/network-api/clients/cli

git fetch --tags
git checkout "$(git rev-list --tags --max-count=1)"

# Chạy expect script
expect /app/run_cli.exp
