ARG BUILD_FROM=ghcr.io/home-assistant/base-debian:bookworm
FROM $BUILD_FROM

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install base packages
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        supervisor \
        openssh-server \
        corosync-qnetd \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Configure SSH
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && mkdir -p /run/sshd

# Copy scripts and configuration
COPY set_root_password.sh /usr/local/bin/set_root_password.sh
COPY supervisord.conf /etc/supervisord.conf
COPY run.sh /run.sh

# Set permissions
RUN chmod 755 /usr/local/bin/set_root_password.sh \
    && chmod 755 /run.sh

# Expose ports
EXPOSE 22 5403

# Labels
LABEL \
    org.opencontainers.image.title="Home Assistant App: Proxmox QDevice" \
    org.opencontainers.image.description="External QDevice for Proxmox VE clusters" \
    org.opencontainers.image.source="https://github.com/acon96/proxmox-qdevice-addon" \
    org.opencontainers.image.licenses="MIT"

# Start supervisor
CMD ["/run.sh"]