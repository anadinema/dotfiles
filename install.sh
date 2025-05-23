#!/bin/zsh -e

setopt +o nomatch

LINE=----------------------------------------------------------------

# Function to do multiple steps for setting up for installation
__setup() {

	if [ -z "$RUN_DEFAULTS" ]; then
		RUN_DEFAULTS=0
	fi

	if [ -z "$DOTFILES" ]; then
		DOTFILES=$HOME/dotfiles
	fi

	if [ -z "$WORK_MACHINE_SETUP" ]; then
		WORK_MACHINE_SETUP=0
	fi

	if [ -z "$RUN_WORK_ARCHIVE_SETUP" ]; then
		RUN_WORK_ARCHIVE_SETUP=0
	fi

	if [ -z "$RUN_TOOLS_SETUP" ]; then
		RUN_TOOLS_SETUP=0
	fi

	scripts=($(ls scripts))
	for file in $scripts; do
		chmod +x scripts/$file
	done

  sudo -v
  while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

}

__dev_folders_setup() {
	mkdir -p $HOME/dev/archives
  mkdir -p $HOME/dev/bin
  mkdir -p $HOME/dev/config
	mkdir -p $HOME/dev/repository
	mkdir -p $HOME/dev/artifactory/maven
	mkdir -p $HOME/dev/artifactory/gradle
}

__install_rosetta() {
	echo "$LINE\n ### Installing rosetta... ### \n$LINE"
	softwareupdate --install-rosetta --agree-to-license
	sleep 5
	echo "$LINE\n ### rosetta installed successfully... ### \n$LINE"
}

# Perform the setup/cleanup with the unnecessary files/folder
__file_folder_setup() {
  echo "$LINE\n ### Cleaning up... ### \n$LINE"
  rm -rf $HOME/.lesshst
	rm -rf $HOME/.zcompdump*
	rm -rf $HOME/.zsh_history*
	rm -rf $HOME/.zshrc.pre*
	rm -rf $HOME/.zprofile
  mkdir -p $DOTFILES/temp
  echo "$LINE\n ### All set and good to move ahead... ### \n$LINE"
}


#### Main function run call chain ####

_main() {
  __setup
	__dev_folders_setup
	__install_rosetta
  . scripts/brew-setup.sh
	. scripts/manual-installation.sh
  . scripts/setup-dotfiles.sh
  . scripts/macos-defaults.sh
  . scripts/setup-tools.sh
  . scripts/setup-work-archives.sh
  __file_folder_setup
}


#### Execute the main function ####

_main

# TODO : SUDO is not working fix it

