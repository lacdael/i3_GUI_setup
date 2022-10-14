# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

#Start UI
startx
#Set contrast
#xgamma -gamma 0.7
#Set editor to vim.gtk (for ctl+c/v)
#export EDITOR=vim.gtk
#export NVM_DIR="$HOME/.nvm"
#[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
#[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#export JAVA_HOME=/usr/lib/jvm/openlogic-openjdk-8-hotspot-amd64
#export ANDROID_SDK_ROOT=/opt/Android/Sdk
#export PATH=${PATH}:/opt/Android/Sdk/platform-tools:/opt/Android/Sdk/build-tools
#PATH="$PATH:/opt/flutter/bin"
#PATH="/home/christian/.local/share/solana/install/active_release/bin:$PATH"

alias serve="python -m SimpleHTTPServer"
#alias backup="rsync -avh --delete --exclude-from=rsync-homedir-excludes.txt /home/christian/ /media/christian/BACKUP/SYNC"
alias shutdown="sudo shutdown now"
