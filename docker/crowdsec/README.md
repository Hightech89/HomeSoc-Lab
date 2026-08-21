# CrowdSec Docker Deployment

## Purpose

This folder contains the Docker Compose deployment definition for CrowdSec in the Home SOC lab.

CrowdSec is being introduced as a detection engine first. This deployment does not install a bouncer, firewall integration, or active blocking component.

This deployment uses the pinned Debian CrowdSec image `crowdsecurity/crowdsec:v1.7.8-debian`. The Debian image is required for journald acquisition because it includes the `journalctl` tooling used by the CrowdSec journald datasource. The tag is pinned instead of using `latest-debian` so Home SOC deployments stay reproducible and do not change behavior unexpectedly when upstream images are updated.

## Current Scope

This deployment watches Linux host logs and SSH-related activity from the Raspberry Pi SOC host.

Initial collections:

- `crowdsecurity/linux`
- `crowdsecurity/sshd`

Initial log sources:

- `/var/log/auth.log`
- `/var/log/syslog`
- systemd journal entries for `ssh.service` or `sshd.service`

## Design Decisions

### Detection Before Blocking

This Compose stack runs the CrowdSec Security Engine only.

CrowdSec can detect suspicious activity and produce decisions, but it does not block traffic unless a remediation component, also called a bouncer, is added.

Blocking is intentionally left out for now because active response can disrupt access to the lab if it is configured incorrectly.

### Persistent Volumes

CrowdSec requires persistent storage for `/var/lib/crowdsec/data`.

This deployment also persists `/etc/crowdsec` so local configuration, credentials, machine registration, and hub state survive container replacement.

Named volumes:

- `crowdsec-config` mounted at `/etc/crowdsec`
- `crowdsec-data` mounted at `/var/lib/crowdsec/data`

### Read-Only Host Logs

The host log directory is mounted read-only at `/var/log/host`.

This lets CrowdSec read logs without allowing the container to modify host logs.

### Pinned Debian Image

The deployment uses `crowdsecurity/crowdsec:v1.7.8-debian`.

CrowdSec's default Docker image is intentionally minimal and does not include `journalctl`. The official Docker guidance uses the Debian image variant for journald support. The Home SOC pins a specific Debian tag instead of tracking `latest-debian` so a future container pull does not silently upgrade CrowdSec during normal maintenance.

### Read-Only Host Journal

The host systemd journal directory is mounted read-only at `/run/log/journal` inside the container.

Raspberry Pi OS can write SSH authentication events to the systemd journal instead of `/var/log/auth.log`. The deployment keeps the original file-based acquisition for Linux hosts that still write traditional auth and syslog files, and adds journald acquisition so the Raspberry Pi SOC host can detect SSH authentication failures where they actually appear.

By default, `.env.example` points `HOST_JOURNAL_DIR` to `/run/log/journal`. If the Raspberry Pi uses persistent journald storage, set `HOST_JOURNAL_DIR` to `/var/log/journal` in `.env`; Compose will still mount that host path to `/run/log/journal` inside the container, which keeps the acquisition configuration stable.

### Local API Bound to Loopback

The CrowdSec Local API is bound to `127.0.0.1:8080` by default.

This keeps the API private to the Docker host unless a future service needs access and the exposure is deliberately changed.

### Existing Home SOC Network

The service joins an external Docker network named `homesoc`.

This follows the current Home SOC network direction and avoids silently creating a new network with the wrong scope. If the network does not exist, Compose will fail until it is created.

## Files

- `docker-compose.yml` - Compose deployment for the CrowdSec container
- `.env.example` - Example environment file
- `config/acquis.d/linux.yaml` - Initial log acquisition configuration

## Prerequisites

- Docker installed on the Raspberry Pi
- Docker Compose v2 available as `docker compose`
- Existing `homesoc` Docker network, or a deliberate decision to create it
- Host logs available under `/var/log` for file-based acquisition
- Host journal available under `/run/log/journal` or `/var/log/journal` for Raspberry Pi OS SSH authentication events
- Permission for the container to read the mounted log and journal paths

## Installation

Do not run these commands until you are ready to deploy CrowdSec.

From this folder:

```powershell
Copy-Item .env.example .env
```

On Linux:

```bash
cp .env.example .env
```

If `.env` already exists on the Raspberry Pi, do not overwrite it. Add any new variables from `.env.example` and keep the existing local values that are already correct.

Review `.env` and update any values that differ on the Raspberry Pi.

Confirm the pinned Debian image tag is present:

```bash
CROWDSEC_IMAGE_TAG=v1.7.8-debian
```

Check where journald stores the Raspberry Pi host journal:

```bash
ls -ld /run/log/journal /var/log/journal
journalctl -u ssh.service -n 20
```

If `/var/log/journal` exists and contains the persistent host journal, update `.env`:

```bash
HOST_JOURNAL_DIR=/var/log/journal
```

Otherwise keep the default:

```bash
HOST_JOURNAL_DIR=/run/log/journal
```

If CrowdSec reports permission errors reading journal files, set `CROWDSEC_GID` in `.env` to a host group ID that can read the journal:

```bash
getent group systemd-journal
getent group adm
```

Check whether the Home SOC network exists:

```bash
docker network inspect homesoc
```

If the network does not exist and you are ready to create it:

```bash
docker network create homesoc
```

Validate the Compose file without starting the service:

```bash
docker compose config
```

Deploy only when ready:

```bash
docker compose up -d
```

## First-Run Validation

After deployment, check container health:

```bash
docker compose ps
```

Check CrowdSec logs:

```bash
docker compose logs -f crowdsec
```

Check CrowdSec status:

```bash
docker compose exec crowdsec cscli lapi status
docker compose exec crowdsec which journalctl
docker compose exec crowdsec cscli metrics
docker compose exec crowdsec cscli metrics show acquisition
docker compose exec crowdsec cscli collections list
```

For SSH detection validation, generate a failed SSH login attempt from another machine, then check that acquisition lines increase and alerts appear:

```bash
docker compose exec crowdsec cscli metrics show acquisition
docker compose exec crowdsec cscli alerts list
```

## Maintenance

### View Alerts

```bash
docker compose exec crowdsec cscli alerts list
```

### View Decisions

```bash
docker compose exec crowdsec cscli decisions list
```

Decisions will not block traffic until a bouncer is installed and configured.

### Update Hub Content

```bash
docker compose exec crowdsec cscli hub update
docker compose exec crowdsec cscli hub upgrade
```

### Update the Container Image

Review release notes first, then:

```bash
docker compose pull crowdsec
docker compose up -d crowdsec
```

### Back Up Persistent Volumes

Back up both named volumes before major upgrades or configuration changes.

Volumes:

- `crowdsec-config`
- `crowdsec-data`

Example backup approach:

```bash
docker run --rm \
  -v crowdsec-config:/backup/source:ro \
  -v "$PWD":/backup/output \
  alpine tar czf /backup/output/crowdsec-config-backup.tgz -C /backup/source .

docker run --rm \
  -v crowdsec-data:/backup/source:ro \
  -v "$PWD":/backup/output \
  alpine tar czf /backup/output/crowdsec-data-backup.tgz -C /backup/source .
```

## Adding More Log Sources

Add one acquisition file per data source under `config/acquis.d/`.

Examples of future sources:

- Router or firewall logs
- Reverse proxy logs
- Application logs
- Docker service logs

Document the source, path, parser label, and reason before enabling it.

## Future Work

- Add router or firewall log ingestion after the log source is documented
- Evaluate whether a firewall bouncer is appropriate
- Add notification profiles after alert review workflow is defined
- Add service-level monitoring in Uptime Kuma after deployment
- Record deployment details in the operations workbook after the service is actually deployed

## References

- CrowdSec Docker installation: https://docs.crowdsec.net/u/getting_started/installation/docker/
- CrowdSec Docker image: https://hub.docker.com/r/crowdsecurity/crowdsec
