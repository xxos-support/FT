FROM ubuntu:22.04

# Install ZNC
RUN apt-get update && \
    apt-get install -y znc && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Create non-root user using build ARG
ARG USER_NAME
RUN useradd -m $USER_NAME
USER $USER_NAME
WORKDIR /home/$USER_NAME

# Expose non-SSL port
EXPOSE 10000

# Default run command
CMD ["znc", "--foreground", "--datadir", "/home/$USER/.znc", "--listen", "10000"]
