# Install homebrew and then install all apps if not installed yet

# Install homebrew to further install applications and tools
__install_homebrew() {
  if type brew &>/dev/null; then
    echo "$LINE\n ### homebrew is already installed... skipping installation... ### \n$LINE"
  else
    echo "$LINE\n ### Installing homebrew... ### \n$LINE"
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
    source ~/.zprofile
    brew doctor
    echo "$LINE\n ### homebrew installed... ### \n$LINE"
  fi
}

# Install all the cli tools, apps, fonts using homebrew
__brew_apps() {
  if ! brew list -q | grep bat &>/dev/null; then
    echo "$LINE\n ### Installing brew bundle... ### \n$LINE"

		if [ "$WORK_MACHINE_SETUP" -eq 1 ]; then
    	brew bundle install --file work/apps/Brewfile
		else
			brew bundle install --file apps/Brewfile
		fi

		echo "$LINE\n ### brew bundle installed... ### \n$LINE"
    brew list
    echo "$LINE"
  else
    echo "$LINE\n ### brew bundle is already installed... running upgrade and cleanup instead... ### \n$LINE"
    brew upgrade && brew cleanup
    echo "$LINE"
  fi
}


#### Main function run call chain ####

__install_homebrew
__brew_apps

rm -f ~/.zprofile
