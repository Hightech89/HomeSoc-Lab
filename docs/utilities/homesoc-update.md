# homesoc-update

## Purpose

`homesoc-update` is the standard deployment command for updating Home SOC repository files after changes are pushed from Cyberdeck.

It updates only the local HomeSoc-Lab repository and Home SOC utility commands. It does not modify Docker services, restart containers, or run Docker Compose.

## Installation

From the repository root:

```bash
chmod +x scripts/install-homesoc-update.sh
./scripts/install-homesoc-update.sh
```

The installer places the utility at:

```text
/usr/local/bin/homesoc-update
```

The installer does not create a configuration file. The command discovers the repository using the same approach as `homesoc-status`: current `HOMESOC_REPO`, the current git repository, the script location, and common Home SOC paths.

After installation, run:

```bash
homesoc-update
```

The script can also be run directly from the repository:

```bash
scripts/homesoc-update
```

## Behavior

`homesoc-update` performs these steps:

1. Verifies that `git` is available.
2. Finds the HomeSoc-Lab repository.
3. Runs `git pull`.
4. Compares the commit before and after the pull.
5. Prints a short update summary.
6. Runs every available `scripts/install-homesoc-*.sh` installer.
7. Launches `homesoc-status`.

The installer scripts are expected to be idempotent. Re-running them after every successful pull keeps installed Home SOC utility commands aligned with the repository without trying to infer which utility files changed.

## Safety Boundaries

`homesoc-update` does not:

- Run Docker commands.
- Run Docker Compose.
- Start, stop, restart, recreate, or update containers.
- Change service configuration outside the repository.
- Create `/etc/default` configuration files.

Docker service changes remain manual and documented operations.

## Exit Codes

| Code | Meaning |
| ---: | --- |
| 0 | Update completed and `homesoc-status` ran successfully |
| 10 | HomeSoc-Lab repository was not found |
| 11 | `git` was not found |
| 12 | `git pull` failed or git state could not be read |
| 13 | One or more utility installers failed |
| 14 | `homesoc-status` failed or was not found |

## Dependencies

Required utilities:

- `bash`
- `git`
- `chmod`
- `install`

The installer may use `sudo` when `/usr/local/bin` is not writable by the current user.
