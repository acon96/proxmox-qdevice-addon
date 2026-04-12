# Home Assistant App: Proxmox QDevice

_External Corosync QNetd service for Proxmox VE clusters._

[![Open your Home Assistant instance and show the app store with a specific repository URL pre-filled.](https://my.home-assistant.io/badges/supervisor_store.svg)](https://my.home-assistant.io/redirect/supervisor_store/?repository_url=https%3A%2F%2Fgithub.com%2Facon96%2Fproxmox-qdevice-addon)

![Supports aarch64 Architecture][aarch64-shield]
![Supports amd64 Architecture][amd64-shield]

Proxmox clusters work best with an odd number of votes. In a 2-node cluster, this app supplies the third vote by running `corosync-qnetd`, which lets the first node that boots reach quorum and start workloads normally.

This app must run on a system that is independent of the Proxmox cluster itself. Do not run it inside a VM or container hosted by that same cluster.

## Repository Layout

This repository contains a single Home Assistant app in `proxmox-qdevice/`.

## What It Does

- Exposes SSH so `pvecm qdevice setup` can complete certificate exchange.
- Runs `corosync-qnetd` on port `5403` as the quorum service.
- Keeps both processes supervised inside Home Assistant.
- Publishes multi-architecture images to `ghcr.io/acon96/app-proxmox-qdevice` through GitHub Actions.

## Install

See [QUICKSTART.md](./QUICKSTART.md) for the shortest path from install to a working Proxmox qdevice.

Repository URL for Home Assistant:

```text
https://github.com/acon96/proxmox-qdevice-addon
```

## Configuration

```yaml
root_password: "replace-this-immediately"
ssh_port: 22
qnetd_port: 5403
```

- `root_password`: Required. Proxmox uses this during `pvecm qdevice setup`.
- `ssh_port`: SSH listener for the setup handshake. Default: `22`.
- `qnetd_port`: Corosync QNetd port. Default: `5403`.

Change the default password before starting the app.

## Usage

After the app is running, configure the cluster from any Proxmox node:

```bash
pvecm qdevice setup <home-assistant-ip>
pvecm status
```

You should see total expected votes increase by one and `Qdevice` appear in cluster membership.

## Troubleshooting

- `Connection refused`: Verify the app is running and ports `22` and `5403` are reachable from every Proxmox node.
- `Authentication failed`: Recheck `root_password`, restart the app, and run setup again.
- No quorum improvement: Confirm the app host is independent from the Proxmox cluster and that `pvecm status` shows `Qdevice` online.

## References

- [Home Assistant apps documentation](https://developers.home-assistant.io/docs/apps)
- [Proxmox Cluster Manager documentation](https://pve.proxmox.com/wiki/Cluster_Manager)
- [bcleonard/proxmox-qdevice](https://github.com/bcleonard/proxmox-qdevice)

## License

Released under the MIT License.

[aarch64-shield]: https://img.shields.io/badge/aarch64-yes-green.svg
[amd64-shield]: https://img.shields.io/badge/amd64-yes-green.svg
