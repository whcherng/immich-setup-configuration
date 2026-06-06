#!/bin/bash

SOURCE="/Volumes/photos/"
DESTINATION="/Volumes/photos-copy/"

if [ -d "$SOURCE" ]; then
    echo "Starting Immich database export..."

    # 1. Force Immich's Postgres container to dump the database cleanly into your photos folder
    # (Change 'immich_postgres' if your container has a different name)
    docker exec -t immich_postgres pg_dumpall -c -U postgres > "$SOURCE/immich_db_backup.sql"

    echo "Starting Immich replica sync: $(date)"

    # 2. Sync everything (including the fresh database dump) to the replica disk
    rsync -avh --delete "$SOURCE" "$DESTINATION"

    echo "Sync completed successfully: $(date)"
else
    echo "Error: Source drive '$SOURCE' is not mounted. Sync aborted."
fi
