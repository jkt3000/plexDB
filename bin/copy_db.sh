#!/bin/sh

# Need way to run this command on remote machine
# All these commands are run on the remote plex server machine

# stop server
/var/packages/Plex\ Media\ Server/scripts/start-stop-status stop

# cp database
rm /volume1/Plex/plex.db
cp -f /volume1/Plex/Library/Application\ Support/Plex\ Media\ Server/Plug-in\ Support/Databases/com.plexapp.plugins.library.db /volume1/Plex/plex.db
# start server
/var/packages/Plex\ Media\ Server/scripts/start-stop-status start

