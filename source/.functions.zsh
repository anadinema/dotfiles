# Functions for different stuff

### Common utils

# Manual reload the shell configuration
reload() {
  source ~/.zshrc
}

# Update the changes in system and update dotfiles, then push changes to github
dotup() {
	brew bundle dump --file=$DOTFILES/brew/Brewfile --force && /
	brew bundle --file=$DOTFILES/brew/Brewfile --force cleanup
	rback
	ORIGINAL=$(pwd)
	cd "$DOTFILES"
	git status
	git add . || true
	COMMIT_MESSAGE=$(git status -s | sed 's/ M/M/' | sed 's/??/A/' | sed 's/ D/D/')
	git commit -m "bot : changes in following dotfiles" -m "$COMMIT_MESSAGE" || true
	git push origin master || true
	cd "$ORIGINAL"
}

# Update the raycast backup file with the new generated ones
rback() {
    if [ $(find $DOTFILES/settings/raycast -type f -exec ls -t1 {} + | head -1 | grep Raycast | wc -l) -eq 1 ]; then
        NEW_RAYCAST_BACKUP_FILE=$(find $DOTFILES/settings/raycast -type f -exec ls -t1 {} + | head -1 | grep Raycast)
        echo "Replacing $NEW_RAYCAST_BACKUP_FILE to be the raycast backup"
        mv $DOTFILES/settings/raycast/settings.rayconfig $DOTFILES/settings/raycast/settings.rayconfig.bkp-$(date "+%Y%m%d-%H:%M:%S")
        mv $NEW_RAYCAST_BACKUP_FILE $DOTFILES/settings/raycast/settings.rayconfig
        rm -f $DOTFILES/settings/raycast/Raycast* || true
    fi
}

# Run the dotfiles configuration again
dot() {
	zsh "$DOTFILES"/install.zsh
	reload
}

# Parse unix epoch to ISO date
epoch() {
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    date --date "@$1" +"+%Y-%m-%dT%H:%M:%SZ"
  else
    date -r "$1" '+%Y-%m-%dT%H:%M:%SZ'
  fi
}

# Open intellij Idea
idea() {
  if [ -n "$1" ]; then
    open -a 'IntelliJ IDEA' "$1"
  else
    open -a 'IntelliJ IDEA'
  fi
}

### Git helpers

# Go to repository root folder
groot() {
  root="$(git rev-parse --show-toplevel 2>/dev/null)"
  if [ -n "$root" ]; then
    cd "$root";
  else
    echo "Not in a git repository"
  fi
}

# Pretty git log
gitlog() {
  git log --graph --abbrev-commit --decorate --all \
    --format=format:"%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(dim white) \
    - %an%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n %C(white)%s%C(reset)"
}

# Print git remote
grem() {
  git config --get remote.origin.url | sed -E 's/(ssh:\/\/)?git@/https:\/\//' | sed 's/com:/com\//' | sed 's/\.git$//' | head -n1
}

### Archive and unarchive

# Pack a folder into a .tar.bz2
pack() {
  if [ -z "$1" ]; then
    echo "No directory supplied. \nUsage: $funcstack[1] directory-path"
  elif ! [[ -d $1 ]]; then
    echo "Error: $1 is not a directory."
  else
    tar -cvjSf "$(date "+%F")-$1.tar.bz2" "$1"
  fi
}

# Unpack a .tar.bz2 folder
unpack() {
  if [ -z "$1" ]; then
    echo "No directory supplied. \nUsage: $funcstack[1] directory-path.tar.bz2"
  else
    tar xjf "$1"
  fi
}

### Homebrew common functions

brewit() {
  brew update &&
  brew upgrade &&
  brew autoremove &&
  brew cleanup -s &&
  brew doctor
}

### Docker functions

dstop-all() {
  docker stop $(docker ps -aq)
}

drm-all() {
  docker rm $(docker ps -aq)
}

### Java version manager

jvm() {
  if [ "$1" == "21" ]; then
    export JAVA_HOME="/Library/Java/JavaVirtualMachines/temurin-21.jdk/Contents/Home"
  elif [ "$1" == "17" ]; then
    export JAVA_HOME="/Library/Java/JavaVirtualMachines/temurin-17.jdk/Contents/Home"
  elif [ "$1" == "gvm" ]; then
    export JAVA_HOME="/Library/Java/JavaVirtualMachines/graalvm-jdk-21/Contents/Home"
    export GRAALVM_HOME="/Library/Java/JavaVirtualMachines/graalvm-jdk-21/Contents/Home"
  elif [ "$1" == "gvm-17" ]; then
    export JAVA_HOME="/Library/Java/JavaVirtualMachines/graalvm-17.jdk/Contents/Home"
    export GRAALVM_HOME="/Library/Java/JavaVirtualMachines/graalvm-17.jdk/Contents/Home"
  elif [ "$1" == "11" ]; then
    export JAVA_HOME="/Library/Java/JavaVirtualMachines/temurin-11.jdk/Contents/Home"
  fi

  PATH="$JAVA_HOME/bin:$PATH"
  export PATH
  reload
  java --version
}

### Maven settings file symlink to the maven home.
mvm() {
  rm -f $M2_HOME/conf/settings.xml
  if [ -n "$1" ] && [ "$1" == "pn" ]; then
    ln -s $DOTFILES/stow/.m2/settings-pn.xml $M2_HOME/conf/settings.xml
  else
    ln -s $DOTFILES/stow/.m2/settings.xml $M2_HOME/conf/settings.xml
  fi
}
