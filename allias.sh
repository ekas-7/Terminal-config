#!/bin/bash

ZSHRC="$HOME/.zshrc"

echo "⚙️ Updating your Zsh configuration..."

# Set Powerlevel10k theme
if grep -q '^ZSH_THEME=' "$ZSHRC"; then
  sed -i.bak '/^ZSH_THEME=/c\ZSH_THEME="powerlevel10k/powerlevel10k"' "$ZSHRC"
else
  echo 'ZSH_THEME="powerlevel10k/powerlevel10k"' >> "$ZSHRC"
fi

# Add plugins line with autosuggestions + syntax highlighting
if grep -q '^plugins=' "$ZSHRC"; then
  sed -i.bak '/^plugins=/c\plugins=(git zsh-autosuggestions zsh-syntax-highlighting)' "$ZSHRC"
else
  echo 'plugins=(git zsh-autosuggestions zsh-syntax-highlighting)' >> "$ZSHRC"
fi

# Add VS Code alias if not already present
if ! grep -q "alias code=" "$ZSHRC"; then
  echo "alias code='open -a \"Visual Studio Code\"'" >> "$ZSHRC"
fi

echo "✅ Config updated!"
echo "👉 Run: exec zsh (or restart your terminal) to apply changes."
