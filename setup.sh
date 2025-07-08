#!/bin/zsh

# --------------------------------------------
# Setup terminal formatting and fuzzy search
# --------------------------------------------

echo "🔧 Setting up terminal formatting and fuzzy search..."

# --------------------------------------------
# Check for Powerlevel10k and initialize submodule if missing
# --------------------------------------------
P10K_THEME="$HOME/dotfiles/themes/powerlevel10k/powerlevel10k.zsh-theme"
P10K_CONFIG="$HOME/.p10k.zsh"
DOTFILES_P10K="$HOME/dotfiles/.p10k.zsh"

if [[ ! -f "$P10K_THEME" ]]; then
  echo "⚠️ Powerlevel10k theme not found. Attempting to initialize submodule..."
  git -C "$HOME/dotfiles" submodule update --init --recursive
  if [[ -f "$P10K_THEME" ]]; then
    echo "✅ Powerlevel10k theme downloaded successfully."
  else
    echo "❌ Failed to download Powerlevel10k. Please check your Git submodule configuration."
  fi
fi

# Enable Powerlevel10k instant prompt
P10K_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
if [[ -r "$P10K_CACHE" ]]; then
  source "$P10K_CACHE"
fi

# Load Powerlevel10k theme if it exists
if [[ -f "$P10K_THEME" ]]; then
  source "$P10K_THEME"
else
  echo "⚠️ Powerlevel10k theme still not found. Skipping theme setup."
fi

# Link to provided .p10k.zsh config if not already present
if [[ ! -f "$P10K_CONFIG" ]]; then
  echo "🔗 Linking dotfiles/.p10k.zsh as ~/.p10k.zsh"
  ln -s "$DOTFILES_P10K" "$P10K_CONFIG"
else
  echo "ℹ️ ~/.p10k.zsh already exists. Skipping link."
fi

# --------------------------------------------
# Install and configure fzf
# --------------------------------------------
if ! command -v fzf >/dev/null 2>&1; then
    echo "📦 Installing fzf..."
    if command -v brew >/dev/null 2>&1; then
        brew install fzf
    else
        echo "⚠️ Homebrew not found. Please install fzf manually:"
        echo "    https://github.com/junegunn/fzf"
    fi
fi

# Install fzf keybindings
if command -v brew >/dev/null 2>&1; then
    echo "⚡ Setting up fzf key bindings and shell integration..."
    "$(brew --prefix)/opt/fzf/install" --all --no-update-rc
fi

# Source fzf keybindings if available
FZF_FILE="$HOME/.fzf.zsh"
if [[ -f "$FZF_FILE" ]]; then
    echo "🔑 Enabling fzf keybindings (zsh)..."
    source "$FZF_FILE"
else
    echo "⚠️ fzf keybindings script ($FZF_FILE) not found."
fi

# --------------------------------------------
# Install and configure nvm with default Node.js version
# --------------------------------------------
NVM_DIR="$HOME/.nvm"
if [[ ! -d "$NVM_DIR" ]]; then
    echo "📦 Installing nvm..."
    if command -v curl >/dev/null 2>&1; then
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
        echo "✅ nvm installed successfully."
    else
        echo "⚠️ curl not found. Please install nvm manually:"
        echo "    https://github.com/nvm-sh/nvm#installing-and-updating"
    fi
fi

# Load nvm in current session
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Always install and set Node.js 18 LTS as default
if ! nvm list 18 | grep -q 'v18'; then
    echo "📦 Installing Node.js 18 LTS..."
    nvm install 18
fi
nvm use 18
nvm alias default 18
echo "✅ Node.js 18 LTS installed and set as default."

# --------------------------------------------
# Make changes permanent in local .zshrc
# --------------------------------------------
PROFILE_FILE="$HOME/dotfiles/.zshrc"

# --------------------------------------------
# Symlink ~/.zshrc to dotfiles/.zshrc
# --------------------------------------------
if [[ -f "$HOME/.zshrc" && ! -L "$HOME/.zshrc" ]]; then
    echo "📂 Backing up existing ~/.zshrc to ~/.zshrc.backup"
    mv "$HOME/.zshrc" "$HOME/.zshrc.backup"
fi

if [[ ! -L "$HOME/.zshrc" ]]; then
    echo "🔗 Creating symlink: ~/.zshrc -> ~/dotfiles/.zshrc"
    ln -s "$HOME/dotfiles/.zshrc" "$HOME/.zshrc"
else
    echo "ℹ️ Symlink for ~/.zshrc already exists. Skipping."
fi

# --------------------------------------------
# Finish setup
# --------------------------------------------
echo ""
echo "🎉 Terminal setup complete! Restart your terminal or run:"
echo "    source ~/.zshrc"
