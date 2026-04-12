#!/usr/bin/with-contenv bashio

# Read configuration options
ROOT_PASSWORD=$(bashio::config 'root_password')
SSH_PORT=$(bashio::config 'ssh_port')
QNETD_PORT=$(bashio::config 'qnetd_port')

# Export for set_root_password.sh script
export NEW_ROOT_PASSWORD="${ROOT_PASSWORD}"

# Log startup
bashio::log.info "Starting Proxmox QDevice app..."
bashio::log.info "SSH Port: ${SSH_PORT}"
bashio::log.info "QNetd Port: ${QNETD_PORT}"

# Validate configuration
if [ -z "${ROOT_PASSWORD}" ] || [ "${ROOT_PASSWORD}" = "changeme" ]; then
    bashio::log.warning "=========================================="
    bashio::log.warning "  WARNING: Using default root password!"
    bashio::log.warning "  Please change it in app configuration"
    bashio::log.warning "=========================================="
fi

# Start supervisord
bashio::log.info "Starting services via supervisord..."
exec /usr/bin/supervisord -c /etc/supervisord.conf