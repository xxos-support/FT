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

USER $USER_NAME
WORKDIR /home/$USER_NAME

# Prepare config folder
RUN mkdir -p /home/$USER_NAME/.znc/configs

# Add a pre-seeded config (admin: znc / znc123)
COPY znc.conf /home/$USER_NAME/.znc/configs/znc.conf

# Expose port (Render will route traffic here)
EXPOSE 10000

# Run ZNC with our config
CMD ["znc", "--foreground", "--datadir", "/home/${USER_NAME}/.znc"]
