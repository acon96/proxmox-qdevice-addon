# Home Assistant App: Proxmox QDevice

_External Corosync QNetd service for Proxmox VE clusters._

[![Open your Home Assistant instance and show the app store with a specific repository URL pre-filled.](https://my.home-assistant.io/badges/supervisor_store.svg)](https://my.home-assistant.io/redirect/supervisor_store/?repository_url=https%3A%2F%2Fgithub.com%2Facon96%2Fproxmox-qdevice-addon)

![Supports aarch64 Architecture][aarch64-shield]
![Supports amd64 Architecture][amd64-shield]

Proxmox clusters work best with an odd number of votes. In a 2-node cluster, this app supplies the third vote by running `corosync-qnetd`, which lets the first node that boots reach quorum and start workloads normally.

> Note: This app must run on a system that is independent of the Proxmox cluster itself. **Do not run this app on Home Assistant OS that is running as a VM hosted by your Proxmox cluster.**  I run my Home Assistant instance on a Raspberry Pi, which is a perfect host for a QDevice, that is separate from the Proxmox nodes themselves.

## Install

Install the add-on repository in Home Assistant by clicking the link above OR you can add a repository by going to the Supervisor panel in Home Assistant, clicking on the store icon in the top right, copy/paste the URL of your repository from below into the repository textarea and click on Save.

```text
https://github.com/acon96/proxmox-qdevice-addon
```

## Configuration

Options Available:

- `root_password`: Required. Proxmox uses this during `pvecm qdevice setup`.
- `ssh_port`: SSH listener for the setup handshake. Default: `2223`.
- `qnetd_port`: Corosync QNetd port. Default: `5403`.

Change the default password before starting the app.

## Usage

### 1. Configure SSH on Each Proxmox Node

Since Home Assistant typically uses non-standard SSH ports, you must configure SSH on **every Proxmox cluster node** to use the correct port. On each node, add this to `/root/.ssh/config`:

```bash
Host <home-assistant-ip>
    Port 2223
```

Replace `<home-assistant-ip>` with your Home Assistant host's IP address. If you changed `ssh_port` to a different value, use that instead of `2223`.

### 2. Install Prerequisites on Proxmox Nodes

On **every Proxmox node**, install the QDevice client package:

```bash
apt update && apt install -y corosync-qdevice
```

### 3. Set Up the QDevice

From any Proxmox node, run:

```bash
pvecm qdevice setup <home-assistant-ip>
pvecm status
```

You should see total expected votes increase by one and `Qdevice` appear in cluster membership.

## Troubleshooting

- `Connection refused`: Verify the app is running, ports `2223` and `5403` are reachable from every Proxmox node, and that SSH config is set up correctly on each node.
- `Authentication failed`: Recheck `root_password`, restart the app, and run setup again.
- `corosync-qdevice-net-certutil: command not found`: Install `corosync-qdevice` package on all Proxmox nodes.
- No quorum improvement: Confirm the app host is independent from the Proxmox cluster and that `pvecm status` shows `Qdevice` online.

## References

- [Home Assistant apps documentation](https://developers.home-assistant.io/docs/apps)
- [Proxmox Cluster Manager documentation](https://pve.proxmox.com/wiki/Cluster_Manager)
- [bcleonard/proxmox-qdevice](https://github.com/bcleonard/proxmox-qdevice)

## License

Released under the MIT License.

[aarch64-shield]: https://img.shields.io/badge/aarch64-yes-green.svg
[amd64-shield]: https://img.shields.io/badge/amd64-yes-green.svg
