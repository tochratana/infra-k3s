# Comprehensive K3s Cluster Setup with Optional Components

This project sets up a K3s cluster (standalone or HA) and optionally installs additional components:
- Helm: Kubernetes package manager
- Ingress-Nginx: Ingress controller
- ArgoCD: GitOps continuous delivery tool
- Kubernetes Dashboard: Web-based Kubernetes user interface
- cert-manager: Certificate management controller

## Prerequisites
- Ansible installed on your local machine
- SSH access to target servers

## Usage
1. Update `inventory/hosts.ini` with your server IPs
2. Adjust variables in `inventory/group_vars/all.yml`:
   - Set `k3s_install_mode` to "standalone" or "ha"
   - Set versions as needed
   - Toggle components on/off using `install_*` variables
3. To install, run:
   ```
   ansible-playbook playbooks/install.yml
   ```
4. To uninstall, run:
   ```
   ansible-playbook playbooks/uninstall.yml
   ```

## Components
- K3s: Lightweight Kubernetes (standalone or HA)
- Helm: Package manager for Kubernetes (optional)
- Ingress-Nginx: Ingress controller (optional)
- ArgoCD: GitOps CD tool (optional)
- Kubernetes Dashboard: Web UI (optional)
- cert-manager: Certificate management (optional)

## Customization
- Modify component configurations in the respective `templates/*.yaml.j2` files
- Add new components by creating new roles and adding them to the install/uninstall playbooks
