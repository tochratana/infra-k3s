# 🚀 Infrac K3s — Automated K3s Cluster Setup

Automates provisioning of a **K3s Kubernetes cluster** (standalone or HA) with essential DevOps tooling using **Ansible**. Built by [@tochratana](https://github.com/tochratana).

---

## 📦 Components

| Component | Description |
|---|---|
| **K3s** | Lightweight Kubernetes engine |
| **Helm** | Kubernetes package manager |
| **Ingress-Nginx** | Routes external HTTP/HTTPS traffic |
| **ArgoCD** | GitOps continuous delivery tool |
| **Kubernetes Dashboard** | Web-based cluster UI |
| **cert-manager** | Automatic SSL/TLS certificate management |

---

## ⚡ Prerequisites

```bash
brew install just                    # macOS — task runner
pip install -r requirements.txt      # Python tools (ansible, lint, etc.)
```

---

## 🛠️ Cluster Modes

Set in `inventory/group_vars/all.yml`:

```yaml
k3s_install_mode: "standalone"   # single node — dev/testing
# k3s_install_mode: "ha"         # 3 master nodes — production
```

| Mode | Servers Needed | Fault Tolerant | Use Case |
|---|---|---|---|
| `standalone` | 1 | ❌ | Dev / Testing |
| `ha` | 3 | ✅ | Production |

---

## 🔧 Configuration

**1. Define your servers** in `inventory/hosts.ini`:
```ini
[k3s_cluster]
192.168.56.10 ansible_user=vagrant ansible_ssh_private_key_file=.vagrant/machines/default/virtualbox/private_key

[k3s_masters]
192.168.56.10 ansible_user=vagrant ansible_ssh_private_key_file=.vagrant/machines/default/virtualbox/private_key
```

**2. Toggle components** in `inventory/group_vars/all.yml`:
```yaml
install_helm: true
install_ingress_nginx: true
install_argocd: true
install_dashboard: true
install_cert_manager: true
```

---

## ▶️ Usage (via `just`)

```bash
just              # List all available commands

just install      # Install K3s + all components
just install-k3s  # Install K3s only
just uninstall    # Remove everything
just dry-run      # Preview changes (no apply)
just ping         # Test SSH to all hosts
just lint         # Lint all playbooks
```

---

## 💻 Local Testing with Vagrant

Create a `Vagrantfile` in the repo root:

```ruby
Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/jammy64"
  config.vm.hostname = "k3s-node"
  config.vm.network "private_network", ip: "192.168.56.10"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"
    vb.cpus = 2
  end
end
```

Then:
```bash
just vm-up        # Start the VM
just install      # Provision the cluster
just vm-ssh       # SSH into the VM
just vm-destroy   # Tear down the VM
```

---

## 📁 Project Structure

```
Infrac_k3s/
├── ansible.cfg                  # Ansible global config
├── justfile                     # Task runner commands
├── requirements.txt             # Python tool dependencies
├── setup_3s_ha_etcd.sh          # Manual HA bootstrap script
├── inventory/
│   ├── hosts.ini                # Server inventory
│   └── group_vars/all.yml       # Versions & feature toggles
└── playbooks/
    ├── install.yml              # Main install playbook
    ├── uninstall.yml            # Main uninstall playbook
    └── roles/
        ├── k3s/
        ├── helm/
        ├── ingress_nginx/
        ├── argocd/
        ├── dashboard/
        └── cert_manager/
```

---

## 🔒 Customization

- Adjust component versions in `inventory/group_vars/all.yml`
- Modify configurations in `roles/<component>/templates/*.yaml.j2`
- Add new components by creating a new role and registering it in `install.yml`

