# Aliases to be loaded at the end to keep the list aliases corrected after oh-my-zsh aliases are loaded.

alias c="clear"

alias ls="eza --almost-all --tree --level 2 --group-directories-first --color auto"
alias ll="eza -l --almost-all --group-directories-first --color auto"
alias tree="eza --almost-all --tree --level=5 --icons --group-directories-first --color auto"

alias cat="bat"
alias grep="grep --color"

alias gs="git status"
alias gc="git commit -m"
alias gca="git commit -am"
alias ga="git add"
alias gp="git pull"

alias repo="cd ~/Developer/repository"
alias cdoss="cd /Volumes/OSS/repository"
alias cddot="cd $DOTFILES"

alias ff="fastfetch"
alias code="zed"
alias kubectl="k"

alias mvn="mvn -Dmaven.home=$M2_HOME"
