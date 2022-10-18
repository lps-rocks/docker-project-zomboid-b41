#!/bin/bash

# Exit functions
function stop_server() {
	tmux send-keys -t 0 "save" Enter "quit" Enter 
} 

# Trap 
trap stop_server SIGTERM SIGINT SIGQUIT SIGHUP ERR

# Set the user ID and group id
usermod -u ${PUID} steam
groupmod -g ${PGID} steam 

# Set the ownership of /data to the steam user
chown -Rf steam:steam /home/steam 

# Install server
sudo -u steam /usr/games/steamcmd "+force_install_dir /home/steam/pzserver +login anonymous +app_update ${STEAM_APP} validate +quit"

# Launch server 
sudo -u steam tmux new-session -d /home/steam/pzserver/start-server.sh -servername ${SERVER_NAME} ${SERVER_ADDITIONAL_PARAMS}

# Wait for server to exit
sudo -u steam tmux wait-for 0 

# Exit
exit 0 
