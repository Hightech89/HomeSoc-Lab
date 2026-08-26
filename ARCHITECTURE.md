# Home SOC Architecture

## Purpose

This document describes the current architecture of the Home SOC Lab as documented in this repository.

It is based on:

- `README.md`
- `docs/Project_Overview.md`
- `AGENTS.md`
- `docs/decisions/ProjectPhilosophy`
- `docs/decisions/Roadmap`
- `docs/ideas.md`
- `HomeSOC Reference Sheet.xlsx`
- The current repository folder structure

The Home SOC is a Raspberry Pi based cybersecurity learning environment focused on Linux, Docker, infrastructure monitoring, logging, defensive security, automation, and AI-assisted investigation.

## Current Architecture Summary

The current Home SOC is in the foundation and early monitoring stages.

The documented environment includes:

- Raspberry Pi 4
- Raspberry Pi OS Lite 64-bit
- SSH
- Docker
- Portainer
- Uptime Kuma
- Netdata
- Grafana, installed but currently paused
- CrowdSec, active detection-only with validated SSH brute-force detection
- External SSD / log storage
- Home router / firewall

The repository currently documents the intended architecture, includes a reference operations workbook, and contains an active CrowdSec detection-only Compose deployment under `docker/crowdsec/`. Most other service folders remain placeholders and do not yet contain deployable configuration.

## High-Level System View

```text
Operator Workstation
        |
        | Local network access
        v
Home LAN
        |
        v
Raspberry Pi 4
        |
        | SSH administration
        v
Raspberry Pi OS Lite
        |
        v
Docker Runtime
        |
        +-- Portainer
        +-- Uptime Kuma
        +-- Netdata
        +-- Grafana, installed / paused
        +-- CrowdSec, active / detection only
```

## Current Installed Services

### Protected Remote Access

Protected remote access is planned but not documented as active in the reference workbook.

Current role:

- Future remote administration path
- Safer alternative to exposing dashboards directly to the public internet

Current repository status:

- The reference workbook marks internet-to-Home SOC VPN access as planned
- No Tailscale, VPN, or protected remote-access configuration is currently stored in the repository

### SSH

SSH is the primary administrative interface for the Raspberry Pi.

Current role:

- Shell access
- Linux administration
- Service troubleshooting
- Docker management when needed

Current repository status:

- Documented in `README.md`
- No SSH hardening notes, access model, or operations runbook is currently stored in the repository

### Docker

Docker is the core runtime for containerized Home SOC services.

Current role:

- Runs infrastructure and monitoring services
- Provides the foundation for future logging, security, automation, and AI components

Current repository status:

- Documented in `README.md` and `docs/Project_Overview.md`
- CrowdSec has a Docker Compose deployment under `docker/crowdsec/`
- Other active service folders under `docker/` remain placeholders until their running configuration is documented and migrated when useful

### Portainer

Portainer provides a web interface for managing Docker containers, images, networks, and volumes.

Current role:

- Container visibility
- Container lifecycle management
- Learning tool for Docker operations

Current repository status:

- Documented as installed
- Reference port: `9443/TCP`
- No Portainer service documentation, ports, volumes, or backup notes are currently stored in the repository

### Portainer Edge

Portainer Edge is listed in the reference workbook as available on port `8000`.

Current role:

- Future or edge-management endpoint reference
- Not a primary active service in the current documentation

Current repository status:

- Documented only in the reference workbook
- No Portainer Edge configuration or runbook is currently stored in the repository

### Uptime Kuma

Uptime Kuma provides service availability monitoring.

Current role:

- Tracks whether services are reachable
- Provides basic uptime checks and alerting potential
- Helps validate that the lab is operational

Current repository status:

- Documented as installed
- Placeholder folder exists at `docker/uptime-kuma/`
- Reference port: `3001/TCP`
- No monitor list, notification configuration, ports, volumes, or runbook is currently stored in the repository

### Netdata

Netdata provides real-time host and system performance monitoring.

Current role:

- Raspberry Pi resource monitoring
- CPU, memory, disk, network, and container visibility
- Early infrastructure observability

Current repository status:

- Documented as installed
- Placeholder folder exists at `docker/netdata/`
- Reference port: `19999/TCP`
- No Netdata configuration, ports, volumes, dashboard notes, or runbook is currently stored in the repository

### Grafana

Grafana is documented as installed but currently paused.

Current role:

- Future visualization layer for metrics and logs
- Potential dashboard frontend for Prometheus, Loki, or other data sources

Current repository status:

- Documented as installed and paused
- Placeholder folder exists at `docker/grafana/`
- Reference port: `3000/TCP`
- No dashboards, data sources, provisioning files, ports, or runbook are currently stored in the repository

### CrowdSec

CrowdSec is active in Docker Compose as a validated detection-only security service.

Current role:

- Security detection engine
- Initial Linux and SSH log analysis
- Detection-only security layer until a bouncer or other blocking component is approved separately

Current repository status:

- Compose deployment exists at `docker/crowdsec/docker-compose.yml`
- Service README exists at `docker/crowdsec/README.md`
- Environment template exists at `docker/crowdsec/.env.example`
- Initial acquisition file exists at `docker/crowdsec/config/acquis.d/linux.yaml`
- Active in detection-only mode
- Acquires traditional Linux auth/syslog files where present
- Acquires Raspberry Pi OS SSH authentication events from the systemd journal
- Journald acquisition, SSH parser metrics, SSH brute-force scenarios, alerts, and decisions have been validated through live testing
- No remediation component, blocking bouncer, or active blocking path is configured

## Reference Port Inventory

The reference workbook lists these current and planned access points:

| Service | Port | Expected URL | Status |
| --- | ---: | --- | --- |
| Portainer | 9443 | `https://<raspberry-pi-ip>:9443` | Running |
| Portainer Edge | 8000 | `http://<raspberry-pi-ip>:8000` | Available |
| Grafana | 3000 | `http://<raspberry-pi-ip>:3000` | Installed / paused |
| Netdata | 19999 | `http://<raspberry-pi-ip>:19999` | Running |
| Uptime Kuma | 3001 | `http://<raspberry-pi-ip>:3001` | Running |
| SSH | 22 | `ssh josh@<raspberry-pi-ip>` | Enabled |
| CrowdSec Local API | 8080 | `http://127.0.0.1:8080` | Active / detection only |
| Prometheus | 9090 | `http://<raspberry-pi-ip>:9090` | Planned |

## Current Asset Inventory

The reference workbook lists these current assets:

| Asset ID | Asset | Type | Current State |
| --- | --- | --- | --- |
| `SOC-PI-01` | Raspberry Pi SOC Host | Server | Active |
| `NET-RTR-01` | Home Router / Firewall | Network | Active |
| `NAS-LOG-01` | External SSD / Log Storage | Storage | Active |
| `ENDPOINTS` | Family Devices | Endpoint group | Partially monitored |

## How Services Interact

The current interaction model is simple and appropriate for the foundation stage:

```text
User
  |
  +-- Local network access to dashboards
  |
  +-- SSH provides command-line administration
  |
  +-- Protected remote access is planned
  |
  v
Raspberry Pi OS
  |
  +-- Docker runs SOC services
      |
      +-- Portainer manages Docker resources
      |
      +-- Uptime Kuma checks service availability
      |
      +-- Netdata observes host and container performance
      |
      +-- Grafana is installed but paused until useful data sources exist
      |
      +-- CrowdSec detects Linux and SSH brute-force activity without active blocking
```

Important current boundaries:

- SSH is the current administration layer.
- Protected VPN-style remote access is planned, not active in the reference workbook.
- Docker is the runtime layer.
- Portainer is the container management layer.
- Uptime Kuma is the availability monitoring layer.
- Netdata is the host and infrastructure metrics layer.
- Grafana is installed but paused until there is enough useful data to visualize.
- CrowdSec is active in detection-only mode and has no bouncer or blocking component configured.

## Planned Architecture Direction

The documented roadmap has the following phases:

1. Foundation
2. Infrastructure
3. Monitoring
4. Logging
5. Security
6. Automation
7. AI

Near-term priorities documented in the repository are:

- Keep Portainer, Netdata, and Uptime Kuma stable
- Document the current Docker network layout
- Decide on the log collector path
- Review CrowdSec acquisition, metrics, alerts, and decisions during normal lab operation
- Wazuh, Loki, and SOC Copilot as upcoming work
- Prometheus and advanced Grafana dashboards as planned or deferred until justified by a stronger data-source need

The long-term vision is a documented Home Security Operations Center capable of:

- Monitoring infrastructure
- Centralizing logs
- Detecting suspicious activity
- Running controlled security experiments
- Practicing incident response
- Using AI to assist investigations without replacing human understanding

## What Is Currently Missing

### Version-Controlled Service Definitions

The repository now contains an active CrowdSec Compose deployment. Other active services are not yet captured as deployable service configuration.

Missing examples:

- Compose files for Portainer, Netdata, Uptime Kuma, and Grafana
- Container image names and versions
- Restart policies
- Network definitions
- Volume definitions
- Environment variable examples
- Port mappings

### Service Documentation

Installed services are listed, but not yet documented in operational detail.

Missing examples:

- Purpose
- Ports
- Networks
- Volumes
- Dependencies
- Backup requirements
- Update procedure
- Troubleshooting steps
- Links to dashboards or local endpoints

### Architecture Diagrams

The repository has a `docs/diagrams/` folder, but no diagrams yet.

Useful future diagrams:

- Current system architecture
- Docker network layout
- Monitoring data flow
- Future logging pipeline
- Future security detection pipeline

### Runbooks

The reference workbook includes checklist and incident-response material, but the repository does not yet include standalone Markdown runbooks.

Useful initial runbooks:

- Restart a container
- Update a container
- Check Raspberry Pi health
- Check disk usage
- Recover a failed service
- Back up service data
- Restore service data

### Logging Pipeline

Logging is planned but not yet implemented.

Missing examples:

- Loki
- Promtail or another log shipper
- Log retention policy
- Log sources
- Dashboard strategy
- Incident review workflow

### Security Detection Layer

CrowdSec is active as the first security detection layer in the lab.

Missing examples:

- Ongoing CrowdSec acquisition and alert validation on the Raspberry Pi
- Wazuh configuration
- Suricata or Zeek design notes
- Detection rules
- Alert review process
- False positive handling

### Automation

Automation is a future phase.

Missing examples:

- Container update workflow
- Backup scripts
- Health check scripts
- Scheduled maintenance
- Notification routing

### AI SOC Copilot

The repository contains an `ai/SOC-Copilot/` placeholder, but no implementation yet.

Potential future responsibilities:

- Summarize incidents
- Explain service behavior
- Correlate logs and metrics
- Assist investigations
- Produce learning-oriented explanations

## Repository Structure Observations

Current structure:

```text
.
+-- AGENTS.md
+-- ARCHITECTURE.md
+-- HomeSOC Reference Sheet.xlsx
+-- LICENSE
+-- README.md
+-- ai/
|   +-- SOC-Copilot/
+-- docker/
|   +-- crowdsec/
|   +-- grafana/
|   +-- netdata/
|   +-- uptime-kuma/
+-- docs/
|   +-- Project_Overview.md
|   +-- ideas.md
|   +-- assets/
|   +-- decisions/
|   +-- diagrams/
|   +-- journal/
+-- screenshots/
+-- scripts/
```

The structure is a good start for a learning-focused infrastructure project. It already separates documentation, Docker-related work, AI work, screenshots, and scripts.

The main gap is that most directories are placeholders. The next improvement should be to make each folder explain its purpose and gradually add real service definitions as the lab matures.

## Repository Structure Recommendations

### Keep Root Files Focused

Recommended root files:

- `README.md` for project introduction and quick orientation
- `PROJECT_OVERVIEW.md` or `docs/Project_Overview.md` for project goals and philosophy
- `ARCHITECTURE.md` for current system architecture
- `AGENTS.md` for AI agent working instructions
- `HomeSOC Reference Sheet.xlsx` for operations inventory and tracking
- `LICENSE`

The repository currently uses `docs/Project_Overview.md`. If the intended convention is uppercase root-level project documents, consider either moving it later or adding a README link to its current location.

### Add Service-Level Documentation

Create one document per installed service.

Recommended structure:

```text
docs/services/
+-- portainer.md
+-- uptime-kuma.md
+-- netdata.md
+-- grafana.md
```

Each service document should include:

- Purpose
- Install method
- Ports
- Volumes
- Networks
- Dependencies
- Backup notes
- Update procedure
- Troubleshooting notes

### Add Docker Compose When Ready

When the current running services are understood well enough, add version-controlled Compose files.

Possible structure:

```text
docker/
+-- compose.yml
+-- grafana/
+-- netdata/
+-- uptime-kuma/
```

Alternative structure if the lab grows:

```text
docker/
+-- monitoring/
|   +-- compose.yml
+-- logging/
|   +-- compose.yml
+-- security/
|   +-- compose.yml
```

For the current project size, a single simple Compose file is probably easier to learn and maintain.

### Add Runbooks

Create a runbook directory:

```text
docs/runbooks/
+-- restart-service.md
+-- update-containers.md
+-- check-pi-health.md
+-- backup-service-data.md
```

Runbooks should be short, practical, and tested against the actual Raspberry Pi.

### Add Network Documentation

Create a network document:

```text
docs/networks.md
```

Include:

- Protected remote-access role
- Local LAN role
- Docker networks
- Exposed ports
- Services that should stay private
- Services that should never be internet-exposed

### Normalize Decision Records

The repository has decision documents under `docs/decisions/`, but the files do not currently use `.md` extensions.

Recommended future naming:

```text
docs/decisions/
+-- adr-001-project-philosophy.md
+-- roadmap.md
```

This will make the files easier to browse and render on GitHub.

### Add a Documentation Index

As documentation grows, add:

```text
docs/README.md
```

That file can link to architecture, services, runbooks, diagrams, roadmap, decisions, journal entries, and ideas.

### Preserve the Learning Journal

The `docs/journal/` folder is a strong fit for this project.

Recommended use:

- One entry per meaningful change
- What changed
- Why it changed
- What was learned
- What broke
- What to revisit later

## Recommended Next Steps

1. Document the currently installed services in `docs/services/`.
2. Add a simple network and ports inventory.
3. Add a first operational runbook for checking Raspberry Pi and Docker health.
4. Review CrowdSec acquisition, alerts, and decisions during normal lab operation.
5. Capture the existing Portainer, Netdata, Uptime Kuma, and Grafana setup in Compose after verifying how each service was installed.
6. Keep Grafana paused until Prometheus, Loki, or another useful data source is ready.

## Architectural Principle

The strongest architectural choice in this project is intentional sequencing.

The lab should continue to grow one layer at a time:

1. Make the current system understandable.
2. Document it.
3. Add one new capability.
4. Verify it works.
5. Write the runbook.
6. Only then move to the next service.

This keeps the Home SOC useful as both an operational lab and a professional learning portfolio.
