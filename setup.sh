#!/bin/bash

set -e  # Exit on error

DOTFILES_DIR="$HOME/Desktop/Dev/Dotfiles"
VSCODE_TARGET="$HOME/.config/Code/User"
ZED_TARGET="$HOME/.config/zed"
ZSHRC_TARGET="$HOME/.zshrc"
GNOME_SHELL_TARGET="$HOME/.config/gnome-shell"

# Ensure target directories exist
mkdir -p "$VSCODE_TARGET" "$ZED_TARGET" "$GNOME_SHELL_TARGET"

# Function to create a symlink with backup
create_symlink() {
    local src="$1"
    local dest="$2"

    if [ -e "$dest" ] || [ -L "$dest" ]; then
        echo "Backing up existing: $dest -> $dest.backup"
        mv "$dest" "$dest.backup"
    fi

    ln -s "$src" "$dest"
    echo "Symlinked: $src -> $dest"
}

# Symlink VSCode files
for file in "$DOTFILES_DIR/vscode/"*; do
    create_symlink "$file" "$VSCODE_TARGET/$(basename "$file")"
done

# Symlink Zed files
for file in "$DOTFILES_DIR/zed/"*; do
    create_symlink "$file" "$ZED_TARGET/$(basename "$file")"
done

# Symlink .zshrc
create_symlink "$DOTFILES_DIR/.zshrc" "$ZSHRC_TARGET"

# Symlink gnome-shell.css
create_symlink "$DOTFILES_DIR/gnome-shell.css" "$GNOME_SHELL_TARGET/gnome-shell.css"

echo "✅ Dotfiles setup complete!"

