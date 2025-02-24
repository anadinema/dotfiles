# Setup the dotfiles from source files and work source files

dotfiles_core_dir=$DOTFILES/core

core=(
	$(find $dotfiles_core_dir -mindepth 1 -maxdepth 1 | grep -v .DS_Store | grep -v .stow-local-ignore | sed "s+$dotfiles_core_dir/++g")
)

work_core=(
	$(find $DOTFILES/work/core -mindepth 1 -maxdepth 1 | grep -v .DS_Store | grep -v .stow-local-ignore | sed "s+$DOTFILES/work/core/++g")
)

# Cleanup the stow-local-ignore from original core
__core_setup() {
	rm -f $dotfiles_core_dir/.stow-local-ignore
	echo \\.DS_Store > $dotfiles_core_dir/.stow-local-ignore
	echo \\.DS_Store > $DOTFILES/work/core/.stow-local-ignore
}

# If the same file/folder is to be symlinked from work, then modify the core list
__perform_work_override() {
	rm -f $DOTFILES/work/core/.stow-local-ignore
	for item in $work_core; do
		echo \\"$item" >> $dotfiles_core_dir/.stow-local-ignore
	done
}

# Main function where the files/folders should be symlinked
__stow_dotfiles() {
  echo "$LINE\n ### Removing existing folder/symlinks if present on user home... ### \n$LINE"

	master_core=()

  __core_setup

	if [ "$WORK_MACHINE_SETUP" -eq 1 ]; then
		__perform_work_override
		master_core=("${core[@]}" "${work_core[@]}")
	else
		master_core=("${core[@]}")
	fi

	# TODO: Check and remove if not needed
  rm -rf "$HOME/.zshrc.pre*"

  if [ -n "$HOME" ]; then
		for item in $master_core; do
			echo "Removing $HOME/$item"
			rm -rf "${HOME:?}/$item"
		done
  fi

	echo "$LINE\n ### Stowing now... ### \n$LINE"

  stow core --target="$HOME"

	if [ "$WORK_MACHINE_SETUP" -eq 1 ]; then
		echo "$LINE\n ### Stowing work config now... ### \n$LINE"
  	stow core --target="$HOME" --dir=work
	fi

  sleep 5
  source $HOME/.zshrc

  if ! echo "$DOTFILES" &>/dev/null; then
    echo "### Either syslink or reload failed... Exiting now.. ### \n$LINE" && exit 1
  else
    echo " ### Stowing completed... ### \n$LINE" && cd "$DOTFILES"
  fi
}

#### Main function run call chain ####

__stow_dotfiles
