FROM ubuntu:22.04

# Install ZNC
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y znc && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Create non-root user using build ARG

# Expose non-SSL port
EXPOSE 10000

# Default run command
CMD ["znc", "--foreground", "--datadir", "/home/$USER/.znc", "--listen", "10000"]
