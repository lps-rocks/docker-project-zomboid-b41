# Build from Debian 11 Slim image
FROM debian:bullseye-slim

# ENV Variables for installing server
ENV STEAM_APP=380870 \
    STEAM_AUTO_UPDATE=false \
    STEAM_INSTALL_PATH="/data" \
    SERVER_NAME="pzserver" \
    SERVER_ADDITIONAL_PARAMS="" \
    PUID=1000 \
    PGID=1000
# Stop apt-get asking to get Dialog frontend
ENV DEBIAN_FRONTEND=noninteractive \
    TERM=xterm

# Enable additional repositories
RUN sed -i -e's/ main$/ main contrib non-free/g' /etc/apt/sources.list

# Add i386 packages
RUN dpkg --add-architecture i386

# Install SteamCMD
RUN apt-get update && \
    apt-get install lib32gcc-s1 steamcmd && \
    apt-get clean

# Clean up APT
RUN rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/* && \
    rm -rf /var/tmp/*

# Add the steam user
RUN adduser \
    --disabled-login \
    --disabled-password \
    --shell /bin/bash \
    --gecos "" \
    --uid ${PUID} \
    --gid ${PGID} \
    steam && \
    usermod -G tty steam

# Copy the entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Expose Ports
EXPOSE 16261/udp
EXPOSE 16262/udp

# Expose Mounts
VOLUME ["/home/steam/Zomboid", "/home/steam/pzserver"]

ENTRYPOINT ["/entrypoint.sh"]
