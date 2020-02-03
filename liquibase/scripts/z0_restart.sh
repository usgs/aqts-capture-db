#!/bin/bash 
set -e
set -o pipefail
# Restart postgres to make sure we can connect
pg_ctl -D "$PGDATA" -m fast -o "$LOCAL_ONLY" -w restart