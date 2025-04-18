# Install apps manually from cli which are not on brew

__install_aws_cli() {
	if type aws &>/dev/null; then
    	echo "$LINE\n ### AWS is already installed... skipping installation... ### \n$LINE"
	else
		curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "$HOME/dev/archives/AWSCLIV2.pkg"
		sudo installer -pkg $HOME/dev/archives/AWSCLIV2.pkg -target /
		echo "$LINE\n ### AWS is installed now... ### \n$LINE"
		aws --version
	fi
}

__install_sdkman() {
	curl -s "https://get.sdkman.io?rcupdate=false" | bash
	echo "$LINE\n ### SDKman is installed now... ### \n$LINE"
}


#### Main function run call chain ####

__install_aws_cli
__install_sdkman
