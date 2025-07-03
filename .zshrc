
# Powerlevel10k theme
if [[ -r "$HOME/dotfiles/themes/powerlevel10k/powerlevel10k.zsh-theme" ]]; then
  source "$HOME/dotfiles/themes/powerlevel10k/powerlevel10k.zsh-theme"
fi

# To customize prompt, run `p10k configure` or edit $HOME/.p10k.zsh
[[ -f $HOME/.p10k.zsh ]] && source $HOME/.p10k.zsh

# fzf keybindings
if [[ -r "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh" ]]; then
  source "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh"
fi

# Load private bash secrets
if [[ -f "$HOME/.bash_secrets" ]]; then
  source "$HOME/.bash_secrets"
fi
