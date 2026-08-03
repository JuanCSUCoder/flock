# Flock 🐦‍⬛

> **Orchestrate parallel AI agents in isolated git worktrees.**

**Flock** is a CLI tool designed to streamline multi-agent development workflows. It spins up containerized, branch-native execution environments using Docker and Git Worktrees—allowing AI agents to build, test, and commit code concurrently without polluting your local workspace or colliding with each other.

---

## Installation

You can quickly install Flock using the official installation script:

```bash
curl -fsSL [https://juancsucoder.github.io/flock/install_flock.sh](https://juancsucoder.github.io/flock/install_flock.sh) | bash
```

---

## Core Architecture & Features

* **Git Worktree Isolation**: Automatically creates dedicated Git worktrees and feature branches (`feature/agent-<name>`). This keeps all agent changes isolated on disk so you can easily review, test, and merge them into your main branch.
* **OpenCode Configuration Binding**: Mounts your local OpenCode configuration and API keys directly into the execution container, ensuring seamless agent authentication without extra setup.
* **Isolated Network Stack**: Runs agents inside isolated Docker network environments. Agents can safely spin up web servers, databases, and microservices on local ports without interfering with host ports or other parallel agent sessions.
* **Automatic Environment Hygiene**: Handles project metadata and `.gitignore` updates automatically to keep temporary worktrees and session state files out of your source control.

---

## Quickstart

To spin up an isolated containerized session for an agent, simply pass your desired session or task name to `flock`:

```bash
flock test1
```

### Example Terminal Output

```text
❯ flock test1
Line added to gitignore.
Line added to gitignore.
Preparing worktree (new branch 'feature/agent-test1')
HEAD is now at e0101ca Fix: Permissions
                                    ▄     
  █▀▀█ █▀▀█ █▀▀█ █▀▀▄ █▀▀▀ █▀▀█ █▀▀█ █▀▀█
  █  █ █  █ █▀▀▀ █  █ █   █  █ █  █ █▀▀▀
  ▀▀▀▀ █▀▀▀ ▀▀▀▀ ▀▀▀▀ ▀▀▀▀ ▀▀▀▀ ▀▀▀▀ ▀▀▀▀

  Session    Worktree task with commit guidelines
  Continue   opencode -s ses_03b1c817affeMmzJicE4qcQs8B
```

---

## Workflow Overview

1. **Provision**: `flock` updates `.gitignore` and creates a local Git worktree for the requested session (`feature/agent-<session_name>`).
2. **Containerize**: Spins up a Docker container, binding your host's local OpenCode configs/API keys and mounting the isolated worktree directory into the container.
3. **Isolate**: Assigns a dedicated network bridge so agent-driven servers and services run in complete isolation from your machine's host network.
4. **Review & Merge**: Inspect the generated commits and branch directly from your primary repository, then merge or iterate as needed.

---

## License

Distributed under the MIT License. See `LICENSE` for details.