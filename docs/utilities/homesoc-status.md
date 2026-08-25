# homesoc-status

## Purpose

`homesoc-status` is the first operational dashboard command for the Home SOC.

It provides a one-screen summary of host health, network access, Docker state, key SOC services, CrowdSec status, repository state, and project metadata.

The utility is read-only. It does not start, stop, restart, install, remove, or modify services.

## Installation

From the repository root:

```bash
chmod +x scripts/install-homesoc-status.sh
./scripts/install-homesoc-status.sh
```

The installer places the utility at:

```text
/usr/local/bin/homesoc-status
```

It also writes the local repository path to:

```text
/etc/default/homesoc-status
```

That file sets `HOMESOC_REPO` so installed runs can read project metadata from the repository regardless of the current working directory.

After installation, run:

```bash
homesoc-status
```

If the repository is moved after installation, rerun the installer from the new location or set `HOMESOC_REPO` for the current shell:

```bash
export HOMESOC_REPO=/path/to/HomeSoc-Lab
```

The script can also be run directly from the repository:

```bash
scripts/homesoc-status
```

## Example Output

```text
═══════════════════════════════════════
 HOME SOC STATUS
═══════════════════════════════════════

System
  Hostname               homesoc-pi
  Current date/time      2026-08-24 14:30:00 CDT
  Uptime                 up 3 days, 4 hours, 12 minutes
  Kernel version         6.12.34+rpt-rpi-v8
  CPU temperature        47.8 C
  CPU usage              8.2%
  Memory usage           912MiB / 3792MiB (24.1%)
  Disk usage             18G / 109G (17%)

Network
  Local IP               192.168.1.50
  Tailscale IP           Not installed

Docker
  Docker version         28.3.3
  Docker Compose version 2.39.1
  Running containers     4

Services
  Portainer              🟢 Running
  Netdata                🟢 Running
  Uptime Kuma            🟢 Running
  CrowdSec               🟢 Running
  Grafana                🔴 Stopped

CrowdSec
  Active alerts          0
  Active decisions       0
  Parser count           12

Git
  Current branch         main
  Working tree           Clean
  Last commit            abc1234 Add CrowdSec container

═══════════════════════════════════════
  Home SOC Version       v0.3 - CrowdSec detection baseline
  Current Sprint         Learn CrowdSec, Explore metrics and alerts
  Project State Version  0.3
═══════════════════════════════════════
```

The real output uses ANSI colors.

## Dependencies

Required standard Linux utilities:

- `bash`
- `awk`
- `sed`
- `hostname`
- `date`
- `uptime`
- `uname`
- `free`
- `df`
- `top`

Optional utilities:

- `docker` for Docker and service status
- `docker compose` or `docker-compose` for Compose version
- `tailscale` for Tailscale IP detection
- `git` for repository status

CrowdSec details require:

- A running CrowdSec container
- `cscli` available inside that container
- Permission for the current user to run Docker commands

## Future Enhancements

- Add service ports and dashboard URLs.
- Add service health status when containers expose health checks.
- Add Docker network and volume summaries.
- Add backup freshness checks.
- Add update availability checks.
- Add Uptime Kuma monitor status if an API integration is later approved.
- Add log collector status after Loki, Promtail, Wazuh, or another logging path is deployed.
