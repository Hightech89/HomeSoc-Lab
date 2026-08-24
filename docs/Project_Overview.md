# Home SOC Project Overview

## Purpose

The Home SOC (Security Operations Center) project is a long-term cybersecurity learning environment built on a Raspberry Pi.

The goal is not simply to install software, but to understand how modern security operations, infrastructure monitoring, automation, and AI-assisted analysis work together in a real environment.

This document describes the project goals and direction. The current deployment state is tracked in `project_state.md`, and architecture details are tracked in `ARCHITECTURE.md`.

## Project Goals

- Learn Linux administration
- Learn Docker and container management
- Build experience with enterprise monitoring tools
- Learn defensive cybersecurity concepts
- Practice infrastructure documentation
- Develop automation skills
- Build AI-powered SOC tooling
- Create a professional portfolio project

## Core Principles

### Simplicity First

Choose the simplest solution that solves the current problem.

Avoid unnecessary complexity.

### Learn by Building

Every major component should teach a new skill.

Understanding is more important than collecting software.

### Documentation Matters

Every meaningful change should be documented.

Documentation is considered part of the implementation.

### Treat the Lab Like Production

Maintain documentation.

Track changes.

Write runbooks.

Keep the environment organized.

## Current Environment

### Hardware

- Raspberry Pi 4

### Operating System

- Raspberry Pi OS Lite (64-bit)

### Current Assets

- Raspberry Pi SOC host
- Home router / firewall
- External SSD / log storage
- Family endpoint group

### Current Services

- Docker
- Portainer
- Netdata
- Uptime Kuma
- CrowdSec (active, detection-only, Docker Compose managed)
- Grafana (installed, currently paused)

## Near-Term Roadmap

### Current Priority

- Keep Portainer, Netdata, and Uptime Kuma stable
- Document the current Docker network layout
- Continue learning CrowdSec metrics and alert behavior

### Upcoming

- Decide on the log collector path
- Wazuh
- Loki
- SOC Copilot

### Deferred

- Prometheus
- Advanced Grafana dashboards

## Documentation Structure

The `docs/` directory is intended to organize the project documentation into the following areas:

- Architecture
- Services
- Networks
- Runbooks
- Roadmap
- Learning Journal
- Ideas

## Success Criteria

This project should become:

- A learning platform
- A portfolio project
- A documented Home SOC
- A foundation for future AI-assisted security tooling

Every improvement should move the project toward those goals.
