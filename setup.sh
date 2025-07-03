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
# Make changes permanent in local .zshrc
# --------------------------------------------
PROFILE_FILE="$HOME/dotfiles/.zshrc"

# Add Powerlevel10k theme and fzf keybindings to .zshrc if not already present
if ! grep -q "Powerlevel10k theme" "$PROFILE_FILE" 2>/dev/null; then
    {
        echo ""
        echo "# Powerlevel10k theme"
        echo "if [[ -f \"$P10K_THEME\" ]]; then"
        echo "  source \"$P10K_THEME\""
        echo "fi"
        echo ""
        echo "# To customize prompt, run \`p10k configure\` or edit \$HOME/.p10k.zsh"
        echo "[[ -f \$HOME/.p10k.zsh ]] && source \$HOME/.p10k.zsh"
        echo ""
        echo "# fzf keybindings"
        echo "if [[ -f $FZF_FILE ]]; then"
        echo "    source $FZF_FILE"
        echo "fi"
    } >> "$PROFILE_FILE"
    echo "✅ Added Powerlevel10k and fzf settings to $PROFILE_FILE"
else
    echo "ℹ️ Powerlevel10k and fzf settings already present in $PROFILE_FILE (skipping)."
fi

# --------------------------------------------
# Add sourcing of ~/.bash_secrets to .zshrc if not already present
# --------------------------------------------
if ! grep -q "source ~/.bash_secrets" "$PROFILE_FILE" 2>/dev/null; then
    {
        echo ""
        echo "# Load private bash secrets"
        echo "if [[ -f \"\$HOME/.bash_secrets\" ]]; then"
        echo "  source \"\$HOME/.bash_secrets\""
        echo "fi"
    } >> "$PROFILE_FILE"
    echo "✅ Added ~/.bash_secrets sourcing to $PROFILE_FILE"
else
    echo "ℹ️ ~/.bash_secrets already sourced in $PROFILE_FILE (skipping)."
fi

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
