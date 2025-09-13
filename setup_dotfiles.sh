#!/usr/bin/env bash
#
# Dotfiles setup script
# ----------------------
# - Backs up existing dotfiles into a timestamped directory
# - Creates symlinks from project dotfiles into $HOME
# - Ensures zsh + oh-my-zsh are installed
# - Installs zsh plugins (zsh-autosuggestions)
# - Installs vim-plug for vim plugin management
# - Configures iTerm2 to use dotfiles preferences
#

# ------------------------------
# 1. Ensure zsh and oh-my-zsh
# ------------------------------

# Check if zsh is installed, install if missing
if ! command -v zsh >/dev/null 2>&1; then
  echo "zsh not found, installing..."
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    sudo apt update && sudo apt install -y zsh   # Debian/Ubuntu
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    brew install zsh   # macOS with Homebrew
  else
    echo "Unsupported OS, please install zsh manually."
    exit 1
  fi
else
  echo "zsh already installed."
fi

# Check if oh-my-zsh is installed, install if missing
if [ ! -d "${ZSH:-$HOME/.oh-my-zsh}" ]; then
  echo "oh-my-zsh not found, installing..."
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo "oh-my-zsh already installed."
fi


# ------------------------------
# 2. Backup & symlink dotfiles
# ------------------------------

echo "creating symlinks for project dotfiles..."
pushd dotfiles > /dev/null 2>&1
now=$(date +"%y%m%d.%H.%M")

for file in .*; do
  if [[ $file == "." || $file == ".." ]]; then
    continue
  fi
  echo "processing ~/$file"

  # If file already exists in $HOME, back it up
  if [[ -e ~/$file ]]; then
      mkdir -p ~/.dotfiles_backup/$now
      mv ~/$file ~/.dotfiles_backup/$now/$file
      echo "backup saved as ~/.dotfiles_backup/$now/$file"
  fi

  # Remove any stale symlink quietly
  unlink ~/$file > /dev/null 2>&1

  # Create new symlink from repo to $HOME
  ln -s ~/.dotfiles/dotfiles/$file ~/$file
  echo "→ linked"
done

popd > /dev/null 2>&1


# ------------------------------
# 3. Install zsh plugins
# ------------------------------

# Install zsh-autosuggestions if missing
if [ ! -d ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]; then
  echo "installing zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions \
    ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
else
  echo "zsh-autosuggestions already installed."
fi


# ------------------------------
# 4. Install vim-plug
# ------------------------------

# Install vim-plug if missing
if [ ! -f ~/.vim/autoload/plug.vim ]; then
  echo "installing vim-plug..."
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
else
  echo "vim-plug already installed."
fi


# ------------------------------
# 5. Configure iTerm2 (macOS only)
# ------------------------------

if [[ "$OSTYPE" == "darwin"* ]]; then
  echo "configuring iTerm2 preferences..."
  defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "~/.dotfiles/dotfiles/.iterm2"
  defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true
fi

echo "✅ Setup complete."
