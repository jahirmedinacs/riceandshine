# riceandshine 🌅

A repository for storing dotfiles and Ansible scripts to replicate my Arch Linux setup. "Rice and shine" because a beautiful, customized Linux desktop setup (rice) is the best way to start your day!

## 📁 Repository Structure

```
riceandshine/
├── ansible/             # Ansible playbooks and roles for system automation
│   ├── playbooks/      # Ansible playbooks for system configuration
│   ├── roles/          # Reusable Ansible roles
│   └── inventory/      # Inventory files for different hosts
├── dotfiles/           # Configuration files for various applications
│   ├── config/         # Application configuration files (.config)
│   ├── scripts/        # Shell scripts and utilities
│   └── home/           # Files that go in the home directory
├── cleanup.sh          # Script for temporary file cleanup
├── README.md           # This file
└── LICENSE             # MIT License
```

## 🚀 Quick Start

### Prerequisites

- Arch Linux (or Arch-based distribution)
- Git
- Ansible (for automated setup)
- GNU Stow (optional, for dotfiles management)

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/jahirmedinacs/riceandshine.git
   cd riceandshine
   ```

2. **Install Ansible (if not already installed):**
   ```bash
   sudo pacman -S ansible
   ```

3. **Run Ansible playbooks (after creating your own):**
   ```bash
   cd ansible
   # Create your playbook first (see ansible/README.md for examples)
   ansible-playbook -i inventory/hosts playbooks/your-setup.yml
   ```

4. **Deploy dotfiles:**
   ```bash
   # Using GNU Stow (recommended)
   # First, structure your dotfiles to match your home directory layout
   sudo pacman -S stow
   cd dotfiles
   # Example: if you have dotfiles/home/.bashrc, this will symlink it to ~/.bashrc
   stow -t ~ home
   
   # Or manually copy files (adjust paths as needed)
   cp -r dotfiles/config/* ~/.config/ 2>/dev/null || true
   # Copy dotfiles from home directory (if any exist)
   find dotfiles/home -maxdepth 1 -name '.*' -type f -exec cp {} ~/ \;
   ```

## 🧹 System Maintenance

Use the included cleanup script to keep your system tidy:

```bash
# Show what would be cleaned (dry run)
./cleanup.sh --dry-run

# Perform cleanup with verbose output
./cleanup.sh --verbose

# Show help
./cleanup.sh --help
```

The cleanup script removes:
- Old package cache (keeps last 3 versions)
- User cache files
- Thumbnail cache
- Trash
- Old log files (with root)
- Temporary files

## 📦 What Gets Automated

### Ansible Playbooks
- Base system configuration
- Desktop environment setup
- Development tools installation
- Package management
- Service configuration

### Dotfiles
- Shell configuration (bash, zsh)
- Terminal emulator settings
- Window manager configuration (i3, sway, etc.)
- Text editor settings (vim, neovim)
- Git configuration
- Application-specific configs

## 🛠️ Customization

### Adding Your Own Dotfiles

1. Add your configuration files to the appropriate directory:
   ```bash
   # For home directory files (e.g., .bashrc, .vimrc)
   cp ~/.bashrc dotfiles/home/
   
   # For .config directory files
   cp -r ~/.config/i3 dotfiles/config/
   ```

2. Commit your changes:
   ```bash
   git add .
   git commit -m "Add custom dotfiles"
   git push
   ```

### Creating Ansible Playbooks

1. Create a new playbook in `ansible/playbooks/`:
   ```yaml
   # ansible/playbooks/my-setup.yml
   ---
   - name: My Custom Setup
     hosts: localhost
     become: yes
     tasks:
       - name: Install packages
         pacman:
           name:
             - package1
             - package2
           state: present
   ```

2. Run your playbook:
   ```bash
   ansible-playbook -i inventory/hosts playbooks/my-setup.yml
   ```

## 📝 Best Practices

1. **Keep secrets out of version control**: Use `.env` files or Ansible Vault for sensitive data
2. **Document your changes**: Update READMEs when adding new configurations
3. **Test before committing**: Ensure your changes work on a fresh system
4. **Use version control**: Commit regularly and use meaningful commit messages
5. **Backup before deploying**: Always backup existing configs before overwriting

## 🔒 Security Notes

- Never commit sensitive information (passwords, API keys, tokens)
- Review scripts before running them with elevated privileges
- Use Ansible Vault for sensitive playbook variables
- Regularly update your system and packages

## 🤝 Contributing

This is a personal configuration repository, but feel free to:
- Fork it and adapt it to your needs
- Open issues for bugs or suggestions
- Submit pull requests for improvements

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- The Arch Linux community for excellent documentation
- The dotfiles community for inspiration
- All the open-source projects that make Linux customization possible

## 📚 Resources

- [Arch Linux Wiki](https://wiki.archlinux.org/)
- [Ansible Documentation](https://docs.ansible.com/)
- [GNU Stow](https://www.gnu.org/software/stow/)
- [r/unixporn](https://www.reddit.com/r/unixporn/) for desktop customization inspiration

---

**Made with ❤️ for Arch Linux**