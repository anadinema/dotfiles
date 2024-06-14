#!/bin/zsh

rm -f $M2_HOME/conf/settings.xml

if [ -n "$1" ] && ["$1" == "pn" ]; then
  ln -s $DOTFILES/stow/.m2/settings-pn.xml $M2_HOME/conf/settings.xml
else
  ln -s $DOTFILES/stow/.m2/settings.xml $M2_HOME/conf/settings.xml
fi
echo
echo "Current maven settings are as follows: "
echo
cat $M2_HOME/conf/settings.xml
