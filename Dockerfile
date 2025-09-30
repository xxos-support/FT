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

# Copy pre-seeded config
COPY znc.conf /home/$USER_NAME/.znc/configs/znc.conf

# Fix ownership
RUN chown -R $USER_NAME:$USER_NAME /home/$USER_NAME/.znc

# Switch to non-root user
USER $USER_NAME

# Expose port (Render will set $PORT)
EXPOSE 10000

# Run ZNC using the dynamic $PORT
CMD ["sh", "-c", "znc --foreground --datadir /home/$USER_NAME/.znc --makepem --allow-root && \
                    sed -i 's/Port = 10000/Port = ${PORT}/' /home/$USER_NAME/.znc/configs/znc.conf && \
                    znc --foreground --datadir /home/$USER_NAME/.znc"]
