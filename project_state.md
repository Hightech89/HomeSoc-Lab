# Project State

**Version:** 0.3

Last Updated: 2026-08-24

---

# Current Status

The Home SOC is operational and is transitioning from manually managed services to Infrastructure as Code using Docker Compose.

---

# Active Services

| Service | Status | Management |
|----------|---------|------------|
| Docker | Active | System |
| Portainer | Active | Docker |
| Netdata | Active | Portainer |
| Uptime Kuma | Active | Portainer |
| CrowdSec | Active (Detection Only) | Docker Compose |

---

# Installed but Deferred

| Service | Status |
|----------|---------|
| Grafana | Installed / Paused |

---

# Planned

- Wazuh
- Loki
- Home SOC Portal
- AI SOC Copilot

---

# Current Sprint

## Completed

- GitHub repository created
- Project documentation established
- Codex project configured
- CrowdSec deployed with Docker Compose
- CrowdSec verified operational

## In Progress

- Learn CrowdSec
- Explore metrics and alerts

## Next Sprint

- Deploy Wazuh
- Begin centralized endpoint monitoring

---

# Infrastructure

Deployment Methods

- Portainer (legacy services)
- Docker Compose (new services)

Home SOC Operations Toolkit

- `homesoc-status` for read-only operational status checks
- `homesoc-update` for repository and utility deployment after Cyberdeck pushes

Source of Truth

- `project_state.md` is the current deployment-state summary.
- `ARCHITECTURE.md` describes service relationships, ports, and boundaries.
- `HomeSOC Reference Sheet.xlsx` remains the operations manual for inventory, checklists, and operational tracking.

---

# Notes

Current philosophy:

- Prefer Docker Compose for new services.
- Keep existing Portainer services until migration is beneficial.
- Prioritize learning over adding new tools.
