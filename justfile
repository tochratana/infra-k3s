# justfile for Infrac_k3s
# Run `just` to list all available commands

# Default: list all commands
default:
    @just --list

# ─── Install ────────────────────────────────────────────────────────────────

# Install full cluster (K3s + all optional components)
install:
    ansible-playbook playbooks/install.yml

# Install K3s only (no optional components)
install-k3s:
    ansible-playbook playbooks/install_k3s.yml

# ─── Uninstall ──────────────────────────────────────────────────────────────

# Uninstall full cluster
uninstall:
    ansible-playbook playbooks/uninstall.yml

# Uninstall K3s only
uninstall-k3s:
    ansible-playbook playbooks/uninstall_k3s.yml

# ─── Dev / Debug ────────────────────────────────────────────────────────────

# Dry-run install (check mode, no changes applied)
dry-run:
    ansible-playbook playbooks/install.yml --check

# Show all hosts in inventory
inventory:
    ansible-inventory --list -y

# Ping all hosts to verify SSH connectivity
ping:
    ansible all -m ping

# Lint all playbooks and roles
lint:
    ansible-lint playbooks/install.yml

# ─── Vagrant ────────────────────────────────────────────────────────────────

# Start Vagrant VM
vm-up:
    vagrant up

# SSH into Vagrant VM
vm-ssh:
    vagrant ssh

# Destroy Vagrant VM
vm-destroy:
    vagrant destroy -f

# Restart Vagrant VM
vm-reload:
    vagrant reload
