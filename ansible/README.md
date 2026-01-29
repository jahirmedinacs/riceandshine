# Ansible Configuration

This directory contains Ansible playbooks and roles for automating Arch Linux system setup.

## Directory Structure

```
ansible/
├── playbooks/       # Ansible playbooks for system configuration
├── roles/           # Reusable Ansible roles
├── inventory/       # Inventory files for different hosts
└── ansible.cfg      # Ansible configuration file (create as needed)
```

## Usage

1. Install Ansible:
   ```bash
   sudo pacman -S ansible
   ```

2. Run a playbook:
   ```bash
   ansible-playbook -i inventory/hosts playbooks/your-playbook.yml
   ```

## Example Playbook Structure

You can create playbooks like:
- `playbooks/base.yml` - Base system setup
- `playbooks/desktop.yml` - Desktop environment configuration
- `playbooks/development.yml` - Development tools installation

Example playbook content:
```yaml
---
- name: Base System Setup
  hosts: localhost
  become: yes
  tasks:
    - name: Update system
      pacman:
        update_cache: yes
        upgrade: yes
```

## Notes

- Add your playbooks to the `playbooks/` directory
- Create reusable roles in the `roles/` directory
- Update inventory files with your target hosts
