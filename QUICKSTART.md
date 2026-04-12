# Quickstart

## 1. Install the App

Preferred install path:

- Home Assistant -> Settings -> Add-ons -> Add-on Store -> Repositories
- Add `https://github.com/acon96/proxmox-qdevice-addon`
- Install `Proxmox QDevice`

For local testing, copy `proxmox-qdevice/` into your Home Assistant local add-ons directory and refresh the add-on store.

## 2. Configure It

Use the Configuration tab:

```yaml
root_password: "use-a-strong-password"
ssh_port: 22
qnetd_port: 5403
```

Change `root_password` before you start the app.

## 3. Start It

- Enable `Start on boot`
- Start the app
- Check logs for the SSH and QNetd startup messages

## 4. Attach the Proxmox Cluster

Run this on one Proxmox node:

```bash
pvecm qdevice setup <home-assistant-ip>
```

If you changed the SSH port, include it:

```bash
pvecm qdevice setup <home-assistant-ip> -p <ssh-port>
```

## 5. Verify Quorum

```bash
pvecm status
```

Expected result for a 2-node cluster:

- `Expected votes: 3`
- `Quorate: Yes`
- `Qdevice` appears in membership

## Fast Troubleshooting

- If setup cannot connect, test reachability to ports `22` and `5403` from Proxmox.
- If authentication fails, restart the app after changing the password.
- If `Qdevice` never appears, confirm the app host is not part of the Proxmox cluster.
