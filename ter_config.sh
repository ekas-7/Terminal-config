#!/bin/bash

# Script to install and configure Oh My Zsh with autocomplete, autosuggestions, syntax highlighting, fzf, and useful aliases on macOS

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

echo "🔹 Installing plugins..."
brew install zsh-autosuggestions zsh-syntax-highlighting fzf

echo "🔹 Configuring fzf..."
$(brew --prefix)/opt/fzf/install --all

ZSHRC="$HOME/.zshrc"

echo "🔹 Updating plugins in $ZSHRC..."
if grep -q "plugins=(" "$ZSHRC"; then
  sed -i '' 's/^plugins=(.*)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting fzf)/' "$ZSHRC" || true
else
  echo "plugins=(git zsh-autosuggestions zsh-syntax-highlighting fzf)" >> "$ZSHRC"
fi

# Ensure plugin sourcing is added
if ! grep -q "zsh-syntax-highlighting" "$ZSHRC"; then
  echo 'source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' >> "$ZSHRC"
fi
if ! grep -q "zsh-autosuggestions" "$ZSHRC"; then
  echo 'source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh' >> "$ZSHRC"
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
alias ll="ls -la"
alias la="ls -A"
alias l="ls -CF"

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
EOF

echo "🔹 Reloading Zsh..."
source "$ZSHRC"

echo "✅ Installation complete! Restart your terminal or run 'exec zsh'."
