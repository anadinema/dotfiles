# Script to copy and setup the archives for work onedrive

# Following variable to be saved to auth-envs
files=(
  $(find $WORK_CONF_BASE_PATH/config -mindepth 1 -maxdepth 1 | sed "s+$WORK_CONF_BASE_PATH/config/++g" | grep -v .DS_Store)
)

__setup_archives() {
  local archive_files=(
    $(printf "%s\n"  "${files[@]}" | grep -v .dmg | grep .zip)
  )

  for file in "${archive_files[@]}"; do
    if [ ! -d "$(echo $HOME/dev/archives/$file | sed "s+.zip++g" )" ]; then
      unzip -n $WORK_CONF_BASE_PATH/config/$file -d $HOME/dev/archives/ > /dev/null
    fi
  done
}

__setup_cli_tools() {
  if [ -d "$HOME/dev/archives/cli-tools" ]; then
    local cli_tools=(
      $(find $HOME/dev/archives/cli-tools -mindepth 1 -maxdepth 1 | sed "s+$HOME/dev/archives/cli-tools/++g" | grep -v .exe)
    )

    for cli in "${cli_tools[@]}"; do
      if [ ! -f "$HOME/dev/bin/$cli" ]; then
        mv $HOME/dev/archives/cli-tools/$cli $HOME/dev/bin
        chmod +x $HOME/dev/bin/$cli
      fi
    done
  fi
}

__setup_init_files() {
  local init_files=(
    $(printf "%s\n"  "${files[@]}" | grep -v .zip)
  )

  for init in "${init_files[@]}"; do
    if [ $(echo $init | grep .dmg | wc -l) -gt 0 ]; then
      if [ ! -f "$HOME/dev/archives/$init" ]; then
        cp $WORK_CONF_BASE_PATH/config/$init $HOME/dev/archives/
      fi
    elif [ ! -f "$HOME/dev/config/$init" ]; then
      cp $WORK_CONF_BASE_PATH/config/$init $HOME/dev/config/
    fi
  done
}

__setup_folder_based_stuff() {
  if [ ! -d "$HOME/dev/containers" ]; then
    cp -r $WORK_CONF_BASE_PATH/containers $HOME/dev/
  fi
  if [ ! -d "$HOME/dev/scripts" ]; then
    cp -r $WORK_CONF_BASE_PATH/scripts $HOME/dev/
  fi
}


if [[ "$WORK_MACHINE_SETUP" -eq 1 ]] && [[ "$RUN_WORK_ARCHIVE_SETUP" -eq 1 ]]; then
  __setup_archives
  __setup_cli_tools
  __setup_init_files
  __setup_folder_based_stuff
fi
