# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

# this seems to work well w/ ansi-term
export PS1='$ '

unset color_prompt force_color_prompt

# # If this is an xterm set the title to user@host:dir
# case "$TERM" in
# xterm*|rxvt*)
#     PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
#     ;;
# *)
#     ;;
# esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

if [ -d /usr/local/etc/bash_completion.d ] && ! shopt -oq posix; then
    . /usr/local/etc/bash_completion.d/*
fi


alias scps="scp -i /home/hitman/chef-repo/.chef/id_rsa"
alias sshS="ssh -i /home/hitman/chef-repo/.chef/id_rsa "
alias b="bundle exec"
#alias gnome-terminal="gnome-terminal -x screen"

export EDITOR=mg

#uname -a | grep 'Ubuntu' 2>&1 > /dev/null
#ret_code=$?
#if [ $ret_code -eq 0 ] ; then
#   gsettings set org.gnome.desktop.interface gtk-key-theme "Emacs"
#fi

TERM=xterm
#TERM=xterm-color

alias tn='tmux new -s "$(basename `pwd`)" || tmux at -t "$(basename `pwd`)"'
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_73.jdk/Contents/Home/
export GRADLE_HOME=/usr/local/gradle-4.5
export M2_HOME=/usr/local/maven
export EC2_HOME=/usr/local/Library/LinkedKegs/ec2-api-tools/libexec/
export SCALA_HOME=/usr/local/Cellar/scala/
export GOROOT=/usr/local/go
export GOPATH=~/pr/go
export GOBIN=$GOPATH/bin
export PACKER_HOME=/usr/local/packer
#alias node="env NODE_NO_READLINE=1 rlwrap node"
alias c=cyclecloud

# ansible fw crap
export DEPARTMENT=CE
export ANSIBLE_INVENTORY=~/dev/fw/config/inventory.py
export ANSIBLE_NOCOWS=1

# alias ssw='source $(which ssw)'
# ssw load

# no longer using this
# load vars to connect to docker
# eval "$(docker-machine env default)"

# this function is needed when using hologram instead of sellsword
function unset_aws {
    unset AWS_ACCESS_KEY AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SECRET_KEY
}

if [ ! -z "$(command -v brew)" ] ; then
   if [ -f $(brew --prefix)/etc/bash_completion ]; then
      . $(brew --prefix)/etc/bash_completion
   fi
fi

export PATH="/Users/hitman/bin:/home/hitman/bin:$GOPATH/bin/bin:/usr/local/sbin:/usr/local/bin:$PATH"

YARN_GLOBAL="~/.config/yarn/global/node_modules/.bin"
export PATH="$YARN_GLOBAL:$PATH"

if [ -f $GOPATH/src/github.com/zquestz/s/autocomplete/s-completion.bash ]; then
    . $GOPATH/src/github.com/zquestz/s/autocomplete/s-completion.bash
fi

# load local secrets
if [ -e ~/.private/.bash_local ] ; then
   source ~/.private/.bash_local
fi     

export GTAGSLIBPATH=$HOME/.gtags/


cc-rdp () {
    # create an RDP tunnel
    bastion="${1}"
    windows="${2}"
    ssh -A -t cyclecloud@"${bastion}"  -L 33890:"${windows}":3389
    exit_code=$?
    if [ ${exit_code} = 0 ] ; then
        echo "Use localhost:33890 to connect to ${windows}"
    else
        echo "Failed to set up rdp tunnel to ${windows}"
        exit ${exit_code}
    fi
}

docker-clean-containers () {
    docker ps -aq --no-trunc -f status=exited | xargs docker rm
}

export NODE_PATH=~/.config/yarn/global/node_modules/

# The next line enables shell command completion for gcloud.
if [ -f '/home/hitman/local/google-cloud-sdk/completion.bash.inc' ]; then . '/home/hitman/local/google-cloud-sdk/completion.bash.inc'; fi
