# Home SOC Lab

A documented home cybersecurity lab focused on Linux, Docker, monitoring, logging, AI, and hands-on learning.

---

## Mission

Home SOC Lab is my long-term engineering project to learn modern infrastructure, cybersecurity, and systems administration by building and operating my own Security Operations Center (SOC) at home.

This started out as a way to find something to do with an extra Raspberry Pi 4 I had laying around, and turned into something I think can be pretty big and fun to build.

Every service added to this lab must solve a real problem and contribute to my understanding of the systems I'm building.

---

## Why This Exists

Like many people learning cybersecurity, I found myself constantly jumping between projects, tutorials, and new technologies.

This lab is my answer to that.

Instead of trying to learn everything at once, I'm building one system that grows over time.

The goal isn't to build the biggest homelab.

The goal is to become a better engineer.

---

## Guiding Principles

This project follows a few simple rules.

- Understand before installing.
- Every service must solve a real problem.
- Build one layer at a time.
- Documentation is part of the project.
- Learn through experimentation.
- Break things. Fix them. Learn why.
- Security and ethics always come first.
- AI should assist investigation, not replace understanding.

---

## Current Architecture

Current foundation:

- Raspberry Pi 4
- Raspberry Pi OS Lite (64-bit)
- SSH
- Docker
- Portainer
- Uptime Kuma
- Netdata
- Grafana, installed but paused
- CrowdSec, active detection-only
- External SSD / log storage

Current access and operations notes:

- SSH is enabled for administration.
- Portainer, Netdata, and Uptime Kuma are running.
- Grafana is installed but intentionally paused until there is a stronger data-source need.
- CrowdSec is active, managed with Docker Compose, and running in detection-only mode without a bouncer or active blocking.
- Protected remote access is planned; dashboards should not be exposed directly to the public internet.

Future architecture will continue to evolve as new services are added.

For detailed current state, see `project_state.md`. For service relationships and ports, see `ARCHITECTURE.md`.

---

## Home SOC Utilities

Operational helper commands live in `scripts/` and are documented under `docs/utilities/`.

- [`homesoc-status`](docs/utilities/homesoc-status.md) provides a read-only Home SOC status summary.
- [`homesoc-update`](docs/utilities/homesoc-update.md) is the standard deployment command after pushing repository changes from Cyberdeck. It runs `git pull`, reinstalls Home SOC utilities, prints an update summary, and launches `homesoc-status`.

`homesoc-update` only updates repository files and Home SOC utility commands. It does not modify Docker services, restart containers, or run Docker Compose.

Recommended deployment workflow:

1. Push repository changes from Cyberdeck.
2. SSH into the Home SOC host.
3. Run:

```bash
homesoc-update
```

---

## Roadmap

### Phase 1 - Foundation

- Raspberry Pi OS
- SSH
- Local administration
- Protected remote access planning

### Phase 2 - Infrastructure

- Docker
- Portainer

### Phase 3 - Monitoring

- Uptime Kuma
- Netdata
- Grafana, installed but paused
- Prometheus, deferred until needed

### Phase 4 - Logging

- Loki
- Promtail

### Phase 5 - Security

- CrowdSec, active detection-only
- Suricata
- Zeek
- Wazuh or similar

### Phase 6 - Automation

- Container updates
- Backups
- Notifications
- Scheduled maintenance

### Phase 7 - AI

SOC Copilot

An AI assistant designed to summarize incidents, explain system behavior, correlate logs and metrics, and assist with investigations without replacing human analysis.

---

## Learning Philosophy

This repository is intentionally documented as the lab evolves.

The purpose is not only to show what was built, but to capture why it was built, what was learned, and how the architecture changed over time.

Every major milestone will include documentation, screenshots, diagrams, and lessons learned.

---

## Future Vision

The long-term goal is to create a complete Home Security Operations Center capable of:

- Monitoring infrastructure
- Centralizing logs
- Detecting suspicious activity
- Running controlled security experiments
- Practicing incident response
- Integrating AI to assist investigations

Eventually, this lab may become the foundation for future cybersecurity projects and products.

---

## Project Status

Current Version

**v0.3 - CrowdSec detection baseline**

---
