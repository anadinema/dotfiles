# Install apps manually from cli which are not on brew

__install_aws_cli() {
	curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "$HOME/dev/archives/AWSCLIV2.pkg"
	sudo installer -pkg $HOME/dev/archives/AWSCLIV2.pkg -target /
}


#### Main function run call chain ####

__install_aws_cli
