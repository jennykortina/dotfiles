
# Powerlevel10k theme
if [[ -f "/Users/jennykortina/dotfiles/themes/powerlevel10k/powerlevel10k.zsh-theme" ]]; then
  source "/Users/jennykortina/dotfiles/themes/powerlevel10k/powerlevel10k.zsh-theme"
fi

# To customize prompt, run `p10k configure` or edit $HOME/.p10k.zsh
[[ -f $HOME/.p10k.zsh ]] && source $HOME/.p10k.zsh

# fzf keybindings
if [[ -f /Users/jennykortina/.fzf.zsh ]]; then
    source /Users/jennykortina/.fzf.zsh
fi

# Load private bash secrets
if [[ -f "$HOME/.bash_secrets" ]]; then
  source "$HOME/.bash_secrets"
fi
