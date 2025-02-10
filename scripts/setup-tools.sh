# Script to setup some tools to work on code

mvn_version=""
aws_conf_path=$DOTFILES/core/.aws
java_versions=()
node_versions=()

__check_installation() {
	if [ "$(command -v nvm)" != "nvm" ]; then
		echo "\n\n nvm isn't installed.. Quitting!"
	fi

	if type sdk &>/dev/null; then
		echo "\n\n sdkman isn't installed.. Quitting!"
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

	rm -rf $HOME/.sdkman/etc/config
	cp backups/sdkman.config $HOME/.sdkman/etc/config
}

__install_node() {
	for version in $node_versions; do
		if [ $(nvm ls $version | wc -l) -eq 0 ]; then
			nvm install $version
		fi
		nvm alias default ${node_versions[0]}
	done
}

__install_java() {
	for version in $java_versions; do
		if [ $(sdk home java $version | wc -l) -eq 0 ]; then
			sdk install $version
		fi
		sdk default java ${java_versions[0]}
	done
}

__install_maven() {
	if [ $(sdk home maven $mvn_version | wc -l) -eq 0 ]; then
		sdk install $mvn_version
	fi
	sdk default java ${java_versions[0]}
}


#### Main function run call chain ####

envsubst < $aws_conf_path/config.template > $aws_conf_path/config

__check_installation
__setup_versions_and_paths
__install_node
__install_java
__install_maven

