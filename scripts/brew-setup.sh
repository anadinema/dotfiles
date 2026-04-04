# Install homebrew and then install all apps if not installed yet

# Install homebrew to further install applications and tools
__install_homebrew() {
  if type brew &>/dev/null; then
    echo "$LINE\n ### homebrew is already installed... skipping installation... ### \n$LINE"
  else
    echo "$LINE\n ### Installing homebrew... ### \n$LINE"
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    (
      echo
      echo 'eval "$(/opt/homebrew/bin/brew shellenv)"'
    ) >>~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
    source ~/.zprofile
    brew doctor
    echo "$LINE\n ### homebrew installed... ### \n$LINE"
  fi
}

# Install all the cli tools, apps, fonts using homebrew
__brew_apps() {
  local brewfile="apps/Brewfile"
  [[ "$WORK_MACHINE_SETUP" == "1" ]] && brewfile="work/apps/Brewfile"

  echo "$LINE\n ### Syncing homebrew bundle: $brewfile ### \n$LINE"

  # 2. Run bundle install (it handles skips/updates automatically)
  if brew bundle install --file "$brewfile"; then
    echo "$LINE\n ### Bundle sync complete. Cleaning up... ### \n$LINE"
    brew cleanup
  else
    echo "$LINE\n ### homebrew bundle failed to sync fully  ### \n$LINE"
  fi
}

#### Main function run call chain ####

__install_homebrew
__brew_apps
