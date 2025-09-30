FROM ubuntu:22.04

# Install ZNC
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y znc && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Create non-root user (default zncuser)
ARG USER_NAME=zncuser
ENV USER_NAME=$USER_NAME
RUN useradd -m $USER_NAME

USER $USER_NAME
WORKDIR /home/$USER_NAME

# Config directory
RUN mkdir -p /home/$USER_NAME/.znc

# Expose dynamic port (Render injects $PORT)
ENV PORT=10000
EXPOSE $PORT

# Run ZNC
CMD ["znc", "--foreground", "--datadir", "/home/${USER_NAME}/.znc"]
