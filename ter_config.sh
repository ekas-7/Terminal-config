#!/bin/bash

# Script to install and configure Oh My Zsh with Powerlevel10k, plugins, aliases, autocompletion, and color highlighting on macOS

set -e

echo "🔹 Updating Homebrew..."
brew update

echo "🔹 Installing Zsh..."
brew install zsh

echo "🔹 Installing Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo "✅ Oh My Zsh already installed."
fi

ZSHRC="$HOME/.zshrc"
ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}

echo "🔹 Installing plugins into Oh My Zsh custom plugins dir..."
mkdir -p "$ZSH_CUSTOM/plugins"

# zsh-autosuggestions
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
else
  echo "✅ zsh-autosuggestions already installed."
fi

# zsh-syntax-highlighting
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
else
  echo "✅ zsh-syntax-highlighting already installed."
fi

# fzf (still via Homebrew for system-wide integration)
brew install fzf
$(brew --prefix)/opt/fzf/install --all

echo "🔹 Installing Powerlevel10k theme..."
if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
else
  echo "✅ Powerlevel10k already installed."
fi

# Configure theme in .zshrc
if grep -q '^ZSH_THEME=' "$ZSHRC"; then
  sed -i '' 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' "$ZSHRC"
else
  echo 'ZSH_THEME="powerlevel10k/powerlevel10k"' >> "$ZSHRC"
fi

echo "🔹 Updating plugins in $ZSHRC..."
if grep -q "plugins=(" "$ZSHRC"; then
  sed -i '' 's/^plugins=(.*)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting fzf)/' "$ZSHRC" || true
else
  echo "plugins=(git zsh-autosuggestions zsh-syntax-highlighting fzf)" >> "$ZSHRC"
fi

echo "🔹 Adding useful aliases..."
cat << 'EOF' >> "$ZSHRC"

# ------------------------
# Custom Aliases
# ------------------------

# Navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias ~="cd ~"

# Listing
alias ll="ls -la --color=auto"
alias la="ls -A --color=auto"
alias l="ls -CF --color=auto"

# Git
alias gs="git status"
alias ga="git add ."
alias gc="git commit -m"
alias gp="git push"
alias gl="git pull"
alias gco="git checkout"
alias gb="git branch"

# Docker
alias dps="docker ps"
alias dcu="docker compose up"
alias dcd="docker compose down"

# Homebrew
alias brewu="brew update && brew upgrade"

# System
alias cls="clear"
alias c="clear"
alias reload="source ~/.zshrc"

# NPM / Node
alias ni="npm install"
alias nr="npm run"
alias ns="npm start"
alias nt="npm test"
alias nb="npm run build"
EOF

echo "🔹 Configuring autocomplete, history, and colors..."
cat << 'EOF' >> "$ZSHRC"

# ------------------------
# Zsh Completion & History
# ------------------------

# Enable completion system
autoload -Uz compinit
compinit

# History settings
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS       # ignore duplicate commands
setopt HIST_IGNORE_SPACE      # ignore commands starting with space
setopt HIST_VERIFY            # show before running
setopt SHARE_HISTORY          # share across sessions

# Colorized autocomplete menu
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
EOF

echo "✅ Installation complete!"
echo "👉 Starting Zsh with Powerlevel10k theme..."
exec zsh
