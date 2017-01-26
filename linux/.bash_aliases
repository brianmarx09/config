#!/bin/bash
#
# @author Stephen Dunn (snd)
# @since April 1, 2016
#
# Description:
# A minimal (useful) starting point for a Debian-based OS.
# Aliases common commands to cut down on verbosity.
#
# Add additional config to a "~/.bash_extra" file and it will be loaded last.
#
# Installation:
#   
#   1) paste this file in your home directory (~), then from a terminal:
#   2) source ~/.bash_aliases && setup
#
# You will be prompted for your root password to allow basic
# package installation and setup scripts to execute. You only need to
# do those steps once. That's it!
#
# Updating system packages:
#   u
#
# Updating system distribution and packages:
#   uu
#
# Updating system distribution, packages, and configs:
#   uuu
#
# There are many more specific options provided. Just take a look around the
# section containing the update commands to see what's available.
#
# Notes:
# - ****** add any additional config to a "~/.bash_extra" file ******
# - change the default editors if you don't like/have vim + sublime
# - naturally, assumes no conflicts between your other aliases / bash settings
# - commands are listed in order of estimated utility to save you search time
# - aliases are often suffixed w/a ' ' b/c it permits recursive alias expansion
# - see the provided screenrc for a GNU screen integration example
# - see the corresponding bashrc for other minor integration options
#   - e.g., if you want proper colors your bashrc should have
#
#         export TERM=xterm-256color
#
#     or an equivalent statement enabling more than 16 colors in your term

###############################################################################
# clear all previous aliases and PATH (removing quotes via sed)
###############################################################################

# backup path state; if something goes wrong, restored at end
PATH_CACHE=$PATH

# clear path
unalias -a

# obtain default path settings from a standard location (trimming quotes)
export PATH=$(cat /etc/environment | tr -d '"')

# if path is empty, restore previous path settings
[[ -z "${PATH// }" ]] && export PATH=$PATH_CACHE

###############################################################################
# universally used vars
###############################################################################

# color escape seqs for printf / echo
export BLACK='\033[0;30m'
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export BROWN='\033[0;33m'
export ORANGE=$BROWN
export BLUE='\033[0;34m'
export PURPLE='\033[0;35m'
export CYAN='\033[0;36m'
export LIGHT_GRAY='\033[0;37m'
export DARK_GRAY='\033[1;30m'
export LIGHT_RED='\033[1;31m'
export LIGHT_GREEN='\033[1;32m'
export YELLOW='\033[1;33m'
export LIGHT_BLUE='\033[1;34m'
export LIGHT_PURPLE='\033[1;35m'
export LIGHT_CYAN='\033[1;36m'
export WHITE='\033[1;37m'
export NO_COLOR='\033[0m'

###############################################################################
# default apps
###############################################################################

export MY_TERM='lxterminal --geometry=160x40'
export MY_TERM_EDITOR='vim'
export MY_GUI_EDITOR='/usr/bin/subl'
export MY_FILE_MANAGER='pcmanfm'
export MY_DATE_FORMAT='%Y-%m-%d'

# tested oracle java version
export MY_JAVA_VERSION='8'

# build current java repo string
MY_JAVA_REPO1="webupd"
MY_JAVA_REPO2="team/java"
export MY_JAVA_REPO="$MY_JAVA_REPO1$MY_JAVA_VERSION$MY_JAVA_REPO2"

# build current java installer package string
MY_JAVA_INSTALLER1="oracle-java"
MY_JAVA_INSTALLER2="-installer"
export MY_JAVA_INSTALLER="$MY_JAVA_INSTALLER1$MY_JAVA_VERSION$MY_JAVA_INSTALLER2"

# build current java env configuration package string
MY_JAVA_DEFAULT1="$MY_JAVA_INSTALLER1"
MY_JAVA_DEFAULT2="-set-default"
export MY_JAVA_DEFAULT="$MY_JAVA_DEFAULT1$MY_JAVA_VERSION$MY_JAVA_DEFAULT2"

# the tested build of sublime text
export MY_SUBLIME='sublime-text_build-3126_amd64.deb'

###############################################################################
# aliases ordered by necessity, importantce, and re-use elsewhere
###############################################################################

# allow commands to be expanded and provide wrappers for common tasks
alias source='source '
alias bash='bash '
alias sh='sh '
alias sudo='sudo '
alias su='su '
alias gksudo='gksudo '
alias gksu='gksu '
alias nohup='nohup '
alias echo='echo '
alias printf='printf '
alias xargs='xargs '
alias xclip='xclip -selection c '
alias grep='grep '
alias cp='cp '
alias mv='mv '
alias scp='scp '
alias ssh='ssh '
alias push='pushd '
alias pop='popd '
alias rm='rm --one-file-system --preserve-root '
alias date='date +$MY_DATE_FORMAT '
alias ls='ls -AhlsX --color=always '
alias lss='ls --sort=size '
alias less='less -R '
alias stat='stat -c "%a %n" * '
alias del='trash-put'
alias sdel='sudo trash-put'
alias bright='sudo tee /sys/class/backlight/acpi_video0/brightness <<< `cat /sys/class/backlight/acpi_video0/max_brightness`'

# shorthand to pull alias file into caller's terminal (rs ~= "re-source")
alias rs='echo "source ~/.bash_aliases" >> /tmp/rs.bash && chmod +x /tmp/rs.bash && . /tmp/rs.bash && rm /tmp/rs.bash '

# default terminal emulator
alias term='`$MY_TERM` '

# default editors (change these to your favorites)
alias term-editor='`$MY_TERM_EDITOR` '
alias gui-editor='`$MY_GUI_EDITOR` '

# default file manager
alias file-manager='`$MY_FILE_MANAGER` '

# system state
alias shutdown='sudo shutdown -h now '
alias reboot='sudo reboot '

# root user on/off shorthands
alias root-enable='sudo passwd root ; sudo passwd -u root ' #>/dev/null 2>&1 ; sudo passwd -u root >/dev/null 2>&1'
alias root-disable='sudo passwd -l root '

# better default behaviors for standard utils
# package management
alias list='dpkg --list'
alias list-kernels='list | grep linux-image-'
alias list-headers='list | grep linux-headers-'

# dpkg install/uninstall shorthands
alias depends='sudo apt-get -f -y install'
alias dinstall='sudo dpkg -i'
alias install='sudo apt-get -y install'
alias dreinstall='sudo dpkf -r'
alias reinstall='install --reinstall'
alias uninstall='sudo apt-get remove'
alias fix='sudo dpkg --configure -a && update && sudo apt-get -f install && sudo dpkg --configure -a'
alias hold='sudo apt-mark hold'
alias release='sudo apt-mark unhold'

# remove old linux kernel versions
alias clean='sudo apt-get clean'
alias autoclean='sudo apt-get autoclean'
alias autoremove='sudo apt-get autoremove'
alias purge='sudo apt-get -y purge'
alias purge-kernels='list | grep linux-image | cut -d " " -f 3 | sort -V | sed -n "/"`uname -r`"/q;p" | xargs sudo apt-get purge'
alias purge-configs='dpkg -l | grep "^rc" | cut -d " " -f 3 | xargs sudo apt-get purge'
alias cleanup='sudo trash-empty && autoclean && autoremove && rm -f ~/1 ~/.xsession-errors*'

# pull latest bashrc from server or restore prev
alias bashrc-down='(cp -f ~/.bak/.bashrc ~/ && success "bashrc downgrade") || fail "bashrc downgrade" '
alias bashrc-up='\
  push ~ ; \
    del .bak/.bashrc ; \
    mv -f .bashrc .bak/ ; \
    ( \
      wget --timestamping --show-progress --progress=dot --timeout=5 http://raw.githubusercontent.com/entangledloops/config/master/linux/.bashrc && \
      success "bashrc upgrade" 
    ) || (fail "bashrc upgrade" ; bashrc-down) ; \
  pop '

# pull latest vimrc from server or restore prev (this file)
alias alias-down='(cp -f ~/.bak/.bash_aliases ~/ ; source ~/.bash_aliases && success "alias downgrade") || fail "alias downgrade" '
alias alias-up='\
  push ~ ; \
    del .bak/.bash_aliases ; \
    mv -f .bash_aliases .bak/ ; \
    ( \
      wget --timestamping --show-progress --progress=dot --timeout=5 http://raw.githubusercontent.com/entangledloops/config/master/linux/.bash_aliases && \
      source .bash_aliases && \
      success "alias upgrade"
    ) || (fail "alias upgrade" ; alias-down) ; \
  pop '

# pull latest vimrc from server or restore prev
alias vimrc-down='(cp -f ~/.bak/.vimrc ~/ && success "vimrc downgrade") || fail "vimrc downgrade" '
alias vimrc-up='\
  push ~ ; \
    del .bak/.vimrc ; \
    mv -f .vimrc .bak/ ; \
    ( \
      wget --timestamping --show-progress --progress=dot --timeout=5 http://raw.githubusercontent.com/entangledloops/config/master/linux/.vimrc && \
      success "vimrc upgrade"
    ) || (fail "vimrc upgrade" ; vimrc-down) ; \
  pop '

# pull latest bashrc from server or restore prev
alias screenrc-down='(cp -f ~/.bak/.screenrc ~/ && success "screenrc downgrade") || fail "screenrc downgrade" '
alias screenrc-up='\
  push ~ ; \
    del .bak/.screenrc ; \
    mv -f .screenrc .bak/ ; \
    ( \
      wget --timestamping --show-progress --progress=dot --timeout=5 http://raw.githubusercontent.com/entangledloops/config/master/linux/.screenrc && \
      success "screenrc upgrade" 
    ) || (fail "screenrc upgrade" ; screenrc-down) ; \
  pop '

# pull latest vimrc and vim settings folder from server or restore prev
alias vim-down='del ~/.vim >/dev/null 2&>1 ; cp -rf ~/.bak/.vim ~/ ; (vimrc-down && success "vim downgrade") || fail "vim downgrade" '
alias vim-up='vimrc-up && \
  ( \
    push ~ ; \
      echo "backing up vim settings..." ; \
      del .bak/.vim >/dev/null 2>&1 ; \
      mv -f .vim .bak/ ; \
      del entangledloops.com >/dev/null 2>&1 ; \
      ( \
        echo "syncing with latest vim settings..." && \
        svn checkout https://github.com/entangledloops/config/trunk/linux/.vim/ --force && \
        success "vim upgrade"
      ) || (fail "vim upgrade" ; vim-down) && \
      push .vim && \
        mkdir -p bak tmp undo plugin doc && \
        ( \
          push plugin && \
            rm -f surround.vim && \
            wget --timestamping --show-progress --progress=dot --timeout=5 http://raw.githubusercontent.com/tpope/vim-surround/master/plugin/surround.vim && \
          pop && \
          success "plugin download: tpope/plugin/surround.vim" \
        ) || warn "plugin download: tpope/plugin/surround.vim" && \
        ( \
          push doc && \
            rm -f surround.txt && \
            wget --timestamping --show-progress --progress=dot --timeout=5 http://raw.githubusercontent.com/tpope/vim-surround/master/doc/surround.txt && \
          pop && \
          success "doc download: tpope/doc/surround.txt"
        ) || warn "doc download: tpope/doc/surround.txt" && \
      pop && \
    pop \
  ) '

# component update helpers
alias os-upgrade='sudo do-release-upgrade -d '
alias os-up='os-upgrade '
alias gui-update='sudo update-manager -d '
alias gupd='gui-update '
alias update='sudo apt-get update '
alias upd='update && success "update" || fail "update" '
alias upgrade='sudo apt-get upgrade -y '
alias upg='upgrade && success "upgrade" || fail "upgrade" '
alias config-up='alias-up && bashrc-up && vim-up && screenrc-up && rs '
alias dist-upgrade='sudo apt-get dist-upgrade -y '
alias dist-up='source <(sudo echo "dist-upgrade && apt-file update && success \"dist upgrade\"") || fail "dist upgrade" '

# update/upgrade flavors
alias u='source <(sudo echo "upd && upg") ' 
alias uu='source <(sudo echo "u && dist-up") '
alias uuu='source <(sudo echo "config-up && uu") '

# version / system info
alias inodes='df -ih '
alias kernel='uname -r '
alias os='lsb_release -a '
alias os-version="echo $'kernel:\n\t$(kernel)\nos:\n\t$(os | awk -vRS="\n" -vORS="\n\t" '1')' "
alias disk="echo $'inodes:\n$(inodes | awk -vRS="\n" -vORS="\n\t" '1')\n\ndisk:\n$(df | awk -vRS="\n" -vORS="\n\t" '1')\n$(sudo discus)' "
alias vdisk='bg "gksu baobab /" '
alias mem='cat /proc/meminfo '
alias info="echo $'$(mem)\n$(disk)\n$(os-version)' "
alias packages='grep ^ /etc/apt/sources.list /etc/apt/sources.list.d/*'

# generate more entropy
alias random='sudo rngd -f -r /dev/urandom '

# locate hd memory sinks
alias space='sudo du -h --max-depth=1 | sort -hr | less '

# clear scrollback and recent output; annoying leading newline still printed
alias cls='clear && echo -e \\033c '

# clear history and flush the copy in memory to prevent rewrite on exit
alias clear-history='cat /dev/null > ~/.bash_history && history -c && exit'

# shorthand for my favorite console editor
alias svim='sudo vim '
alias vimrc='vim ~/.vimrc '
alias vima='vim ~/.bash_aliases && rs '
alias vime='vim ~/.bash_extra && rs '
alias vimscreenrc='vim ~/.screenrc '
alias vimbashrc='vim ~/.bashrc '

# console editing; replace 'term-editor' target w/your favorite editor
alias edit='gui-editor '
alias sedit='sudo gui-editor '
alias edita='gui-editor ~/.bash_aliases && rs '

# gui editing; replace w/your facorite editor
alias guiedit='gui-editor '
alias sguiedit='sudo gui-editor '
alias guiedita='gui-editor ~/.bash_aliases && rs '

# personal preference for quick access to frequently modified files
alias v='vim '
alias vv='vimrc '
alias va='vima '
alias vs='vimscreenrc '
alias vb='vimbashrc '
alias e='edit '
alias g='guiedit '

# helper for installing requested java
alias install-java="\
  install python-software-properties && \
  add $MY_JAVA_REPO && \
  upd && \
  install $MY_JAVA_INSTALLER $MY_JAVA_DEFAULT "

# helper for sublime text which isn't currently in a public repo
alias install-sublime='\
  push /tmp ; \
    wget --show-progress --progress=dot https://download.sublimetext.com/$MY_SUBLIME && \
    dinstall $MY_SUBLIME && \
    rm -f $MY_SUBLIME >/dev/null 2>&1 &&
    success "sublime install" || \
    fail "sublime install" ; \
  pop '

alias install-bitcoin='\
  add bitcoin/bitcoin && \
  install bitcoin-qt '

# core system utils that are good to have ready
alias setup-system='install \
  linux-headers-$(uname -r) linux-headers-generic dkms lsb-core collectd-core \
  vim-gtk ssh xbindkeys xclip ntfs-3g exfat-fuse exfat-utils trash-cli apt-file \
  cups elinks lynx multitail strace wget gawk sed chkrootkit rkhunter'

# setup a development environment
alias setup-dev='install \
  screen build-essential gcc g++ gdb valgrind git cvs subversion mercurial \
  cmake cmake-gui cmake-curses-gui autoconf libtool pkg-config \
  python-dev python3-dev meld && \
  install-java '

# useful utilities for system monitoring, networking, and other common tasks
alias setup-extras='install \
  gparted htop iotop iftop glances dstat incron sysstat discus systemtap-sdt-dev baobab \
  nmap nmon mtr traceroute tcpdump ethtool ngrep aircrack-ng hydra cutycapt arp-scan \
  gconf-editor gimp audacity filezilla wireshark transmission-gtk vlc-nox vlc blender \
  deluge firefox chromium-browser && \
  install-bitcoin && \
  install-sublime '

# command to prepare a new system
alias setup='\
  setup-system && \
  setup-dev && \
  setup-extras && \
  (mkdir -p ~/.ssh ~/.bak ~/code ~/bin ~/scripts ; config-up ; dist-up ; u) && \
  warn "the system should be rebooted after initial setup" '

###############################################################################
# apps to launch in background
###############################################################################

alias gparted='bg "gksu gparted" '

alias wireshark='bg "wireshark" '
alias swireshark='bg "gksu wireshark" '

alias sublime='bg "subl" '
alias ssublime='bg "sudo subl"' # sublime needs sudo instead of gksu

alias chkrootkit='sudo chkrootkit '
alias rkhunter='sudo rkhunter '

alias firefox='bg "firefox" '
alias chromium='bg "chromium-browser" '
alias chromium-browser='bg "chromium-browser" '
alias gitkraken='bg "gitkraken" '
alias transmission='bg "transmission-gtk" '
alias filezilla='bg "filezilla" '
alias idea='bg "idea"'
alias vlc='bg "vlc"'
alias audacity='bg "audacity"'
alias blender='bg "blender"'

###############################################################################
# functions
###############################################################################

# colorful pre-formatted logging shorthands
function success_helper() { printf "[ ${GREEN}$@ successful${NO_COLOR} ]\n" ; }
alias success='success_helper '

function fail_helper() { printf "[ ${RED}$@ failed${NO_COLOR} ]\n" ; }
alias fail='fail_helper '

function warn_helper() { printf "[ ${YELLOW}$@${NO_COLOR} ]\n" ; }
alias warn='warn_helper '

# system task wrappers
function add() { grep -h "^deb.*$1" /etc/apt/sources.list.d/* >/dev/null 2>&1 ; [ $? -ne 0 ] && (sudo add-apt-repository -y ppa:`echo "$1" | sed "s/ppa://g"` && success "$1 repo add" || fail "$1 repo add") || warn "$1 already present, skipped" ; }
function remove() { grep -h "^deb.*$1" /etc/apt/sources.list.d/* >/dev/null 2>&1 ; [ $? -eq 0 ] && (sudo add-apt-repository --remove -y ppa:`echo "$1" | sed "s/ppa://g"` && success "$1 repo remove" || fail "$1 repo remove") || warn "$1 not present, skipped" ; }
function dhold() { echo "$@ hold" | sudo dpkg --set-selections ; }
function drelease() { echo "$@ install" | sudo dpkg --set-selections ; }

###############################################################################
# basic system task wrappers

# helper for locating docs
function help_helper() 
{ 
  ($@ --help /dev/null 2>&1 && $@ --help) || \
  ($@ -help >/dev/null 2>&1 && $@ -help) || \
  ($@ --h >/dev/null 2>&1 && $@ --h) || \
  ($@ -h >/dev/null 2>&1 && $@ -h) || \
  ($@ -? >/dev/null 2>&1 && $@ -?) || \
  ($@ --? >/dev/null 2>&1 && $@ --?) || \
  (man $@ >/dev/null 2>&1 && man $@) || \
  fail "help lookup" \
  ;
}
alias help='help_helper '

# helper for version info
function version_helper() 
{ 
  ($@ --version >/dev/null 2>&1 && $@ --version) || \
  ($@ -version >/dev/null 2>&1 && $@ -version) || \
  ($@ --v >/dev/null 2>&1 && $@ --v) || \
  ($@ -v >/dev/null 2>&1 && $@ -v) || \
  ($@ --vv >/dev/null 2>&1 && $@ --vv) || \
  ($@ -vv >/dev/null 2>&1 && $@ -vv) || \
  ($@ --ver >/dev/null 2>&1 && $@ --ver) || \
  ($@ -ver >/dev/null 2>&1 && $@ -ver) || \
  ( \
    man $@ >/dev/null 2>&1 && \
    warn "version manually extracted from man pages footer" && \
    local ARGS="${@}" && \
    local PADDING="Version " && \
    local KEEP="$(expr "${#ARGS}" + "${#PADDING}")" && \
    man $@ | grep -i -e "version\+\s*[0-9]\+[^\s]" | tail -1 | sed -e 's/^ *//' | cut -c 1-$KEEP | \
    gawk 'match($0, /[^0-9]*?([0-9][^\ \t]*?)/, matches) { print matches[1] }' \
  ) || \
  fail "version lookup" \
  ;
}
alias version='version_helper '

function push_helper() { pushd $@ >/dev/null 2>&1 ; }
alias push='push_helper '

function pop_helper() { popd $@ >/dev/null 2>&1 ; }
alias pop='pop_helper '

# shorthand to launch and detach a process supressing all output
function bg_helper() { (nohup $@ >/dev/null 2>&1 & disown) >/dev/null 2>&1 ; }
alias bg='bg_helper '

# generic file open; replace w/whatever you want (hex editor, etc.)
function open_helper() { bg "$MY_FILE_MANAGER $@" ; }
alias open='open_helper '
alias sopen='sudo open '

# locate package a file is from
function pkg_helper() { sudo dpkg --search $@ >/dev/null 2>&1; if [ $? != 0 ]; then warn "unable to locate locally, searching repos..." && apt-file search $@; fi ; }
alias pkg='pkg_helper '

# find from pwd filtering errors; don't forget double-quotes, e.g.: find "*.txt"
function find_helper() { \find . -iname "$@" -readable -writable -prune -print ; }
alias find='find_helper '

# find from root filtering errors; don't forget double-quotes, e.g.: findall "*.txt"
function findall_helper() { \find / -iname "$@" 2>&1 | grep -v 'Permission denied' >&2 ; }
alias findall='findall_helper '

###############################################################################
# shorthands and convenient default params for other common tasks

# GNU screen integration
function screen_helper() { [ -z "$STY" ] && screen -RR -A -r "$@" || screen ; }
alias screen='screen_helper '

# git helpers
function gclone_helper() { git clone --verbose $@ ; }
alias gclone='gclone_helper '

function gfetch_helper() { git fetch --all --verbose $@ ; }
alias gfetch='gfetch_helper '

function gpull_helper() { gfetch ; git merge --verbose $@ ; }
alias gpull='gpull_helper '

function gpush_helper() { git push --follow-tags --verbose $@ ; }
alias gpush='gpush_helper '

function gdiff_helper() { [ $# -eq 0 ] && git diff --name-status HEAD@{1} HEAD || git diff --name-status $@ ; }
alias gdiff='gdiff_helper '

function glog_helper() { git log --full-diff --name-only --graph --full-history --no-merges --pretty=format:"%C(bold blue)%an%Creset, %C(yellow)%ar%Creset%n%Cgreen%H%Creset%n%B" $@ ; }
alias glog='glog_helper '

function gcommit_helper() { git add -u ; git commit -m "$@" --verbose ; }
alias gcommit='gcommit_helper '

function gcheckout_helper() 
{ 
  gfetch ; \
  git branch -a | grep "\bremotes/origin/$1$" && \
  ( \
    [ $? -eq 0 ] &&
    ( \
      git show-ref --verify --quit refs/heads/$1 && \
      [ $? -eq 0 ] && git checkout "$@" ||  git checkout -b $1 origin/$1 "${@:2}" \
      ) \
  ) && \
  (gdiff && gpull ; success "checkout") || \
  fail "checkout" \
  ;
}
alias gcheckout='gcheckout_helper '

function gbranch_helper() 
{ 
  git show-ref --verify --quiet refs/heads/$1 ; \
  [ $? -ne 0 ] && (git branch "$@" && success "create branch $1" || fail "create branch $1") || \
  (gcheckout $1 && warn "checked out existing branch $1" || fail "create branch $1") \
  ; 
}
alias gbranch='gbranch_helper '

# OpenSSH -> SSH2 key reformatting
function openssh_to_ssh2_helper() { ssh-keygen -e -f $@ > $1.ssh2 ; }
alias openssh-to-ssh2='openssh_to_ssh2_helper '

# SSH2 -> OpenSSH key reformatting
function ssh2_to_openssh_helper() { ssh-keygen -i -f $@ > $1.openssh ; }
alias ssh2-to-openssh='ssh2_to_openssh_helper '

# air-suite helpers
function aireplay_helper() { aireplay-ng --ignore-negative-one -0 2 -a $2 -c $3 $1; }
alias aireplay='aireplay_helper '

function aireplay_all_helper() { aireplay-ng --ignore-negative-one -0 0 -a $2 $1; }
alias aireplay-all='aireplay_all_helper '

function aircrack_helper() { aircrack-ng -w - -a 2 -e $1 -l $1.pwd $1*.cap; }
alias aircrack='aircrack_helper '

function aircrack_q_helper() { aircrack-ng -q -w - -a 2 -e $1 -l $1.pwd $1*.*; }
alias aircrack-q='aircrack_q_helper '

###############################################################################
# custom
###############################################################################

# load additional mods
if [ -e ~/.bash_extra ]; then
  source ~/.bash_extra
fi

###############################################################################
# env
###############################################################################

# include pwd in path
export JAVA_HOME=$(readlink -f /usr/bin/javac | sed "s:/bin/javac::")
export PATH=$PATH:$JAVA_HOME:$HOME/scripts:.

