FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install ZNC
RUN apt-get update && \
    apt-get install -y znc && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Create non-root user
ARG USER_NAME=zncuser
ENV USER_NAME=$USER_NAME
RUN useradd -m $USER_NAME

WORKDIR /home/$USER_NAME

# Prepare config folder
RUN mkdir -p /home/$USER_NAME/.znc/configs

# Copy config as root
COPY znc.conf /home/$USER_NAME/.znc/configs/znc.conf

# Fix permissions so zncuser owns it
RUN chown -R $USER_NAME:$USER_NAME /home/$USER_NAME/.znc

# Switch to zncuser
USER $USER_NAME

# Expose fixed port
EXPOSE 8443

# Run ZNC
CMD ["znc", "--foreground", "--datadir", "/home/zncuser/.znc"]
