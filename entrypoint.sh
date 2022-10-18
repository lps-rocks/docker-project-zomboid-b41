#!/bin/bash

# Set the user ID and group id
usermod -u ${PUID} steam
groupmod -g ${PGID} steam 

# Set the ownership of /data to the steam user
chown -Rf steam:steam /home/steam 

# Install server
sudo -u steam /usr/games/steamcmd "+force_install_dir /home/steam/pzserver +login anonymous +app_update ${STEAM_APP} validate +quit"

# Launch server 
sudo -u steam /home/steam/pzserver/start-server.sh -servername ${SERVER_NAME} ${SERVER_ADDITIONAL_PARAMS}

# Return exit code of server
exit $?
