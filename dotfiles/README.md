# Dotfiles

This directory contains configuration files (dotfiles) for various applications and tools.

## Directory Structure

```
dotfiles/
├── config/          # Application configuration files
├── scripts/         # Shell scripts and utilities
└── home/            # Files that go in the home directory
```

## Usage

### Manual Installation

Copy dotfiles to their respective locations:

```bash
# Example: Copy bash configuration
cp dotfiles/home/.bashrc ~/
cp dotfiles/home/.bash_profile ~/

# Example: Copy application configs
cp -r dotfiles/config/* ~/.config/
```

### Using Stow (Recommended)

1. Install GNU Stow:
   ```bash
   sudo pacman -S stow
   ```

2. Symlink dotfiles:
   ```bash
   cd dotfiles
   stow -t ~ home
   stow -t ~/.config config
   ```

## Common Dotfiles to Add

- `.bashrc` - Bash shell configuration
- `.bash_profile` - Bash profile
- `.zshrc` - Zsh shell configuration
- `.vimrc` - Vim configuration
- `.gitconfig` - Git configuration
- `.xinitrc` - X initialization
- `.Xresources` - X resources
- `config/i3/` - i3 window manager config
- `config/polybar/` - Polybar config
- `config/nvim/` - Neovim config
- `config/alacritty/` - Alacritty terminal config

## Notes

- Keep sensitive information (passwords, tokens) out of version control
- Use `.env` files or secrets management for sensitive data
- Customize configurations to match your preferences
