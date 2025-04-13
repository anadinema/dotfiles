# Script to setup some tools to work on code

mvn_version=""
aws_conf_path=$DOTFILES/core/.aws
java_versions=()
node_versions=()

__check_installation() {
	if [ "$(command -v nvm)" != 'nvm' ]; then
		nvm --version
		echo "\n\n nvm isn't installed.. Quitting!"
	fi

	if type sdk &>/dev/null; then
		rm -rf $HOME/.sdkman/etc/config
		mkdir -p $HOME/.sdkman/etc
		cp backups/sdkman.config $HOME/.sdkman/etc/config
	else
		echo "\n\n sdkman isn't installed.. Quitting!"
		exit 1
	fi
}

__setup_versions_and_paths() {
	if [ "$WORK_MACHINE_SETUP" -eq 1 ]; then
		mvn_version=3.9.9
		aws_conf_path=$DOTFILES/work/core/.aws
		java_versions=(
			"21.0.6-tem"
			"17.0.14-tem"
			"11.0.26-tem"
		)
		node_versions=(
			"20"
			"22"
		)
	else
		mvn_version=3.9.9
		java_versions=(
			"21.0.6-tem"
		)
		node_versions=(
			"22"
		)
	fi
}

__install_node() {
	for version in $node_versions; do
		if ! nvm ls $version > /dev/null 2>&1; then
			nvm install $version
		fi
		nvm alias default ${node_versions[1]}
	done
}

__install_java() {
	for version in $java_versions; do
		if [ ! -d "$SDKMAN_DIR/candidates/java/$version" ]; then
			sdk install java $version
		fi
	done
	sdk default java ${java_versions[1]}
}

__install_maven() {
	if [ ! -d "$SDKMAN_DIR/candidates/maven/$version" ]; then
		sdk install maven $mvn_version
	fi
	sdk default maven $mvn_version
}

__install_tmux_plugins() {
	if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm "$HOME"/.tmux/plugins/tpm
		echo "\n\n Installed TPM..."
  fi
}


#### Main function run call chain ####

if [ "$RUN_TOOLS_SETUP" -eq 1 ]; then
  envsubst < $aws_conf_path/config.template > $aws_conf_path/config

  __check_installation
  __setup_versions_and_paths
  __install_node
  set +e
  __install_java
  __install_maven
  __install_tmux_plugins
  set -e
fi
