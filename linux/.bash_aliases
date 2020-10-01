#!/bin/bash
#
# @author Stephen Dunn
# @since April 1, 2016
#
# Description:
# A minimal (useful) starting point for a Debian-based OS.
#
# Add additional config to a "$HOME/.bash_extra" file and it will be loaded last.
#
# Installation:
# Paste this file in your home directory and run:
#   source $HOME/.bash_aliases && setup
#
# You will be prompted for your root password to allow basic
# package installation and setup scripts to execute. You only need to
# do those steps once.
#
# Notes:
# - ****** add any additional config to a "$HOME/.bash_extra" file ******
# - aliases are often suffixed w/a ' ' b/c it permits recursive alias expansion
# - if you want proper colors, your bashrc should have
#     export TERM=xterm-256color

###############################################################################
# backup then clear previous state
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
alias cp='cp '
alias mv='mv '
alias scp='scp '
alias ssh='ssh '
alias push='pushd '
alias pop='popd '
alias rm='rm --one-file-system --preserve-root'
alias ls='ls -AhlsX --color=always'
alias lss='ls --sort=size '
alias less='less -R'
alias stat='stat -c "%A %a %n" *'
alias del='trash-put'

# set monitor brightness to max
alias bright='sudo tee /sys/class/backlight/acpi_video0/brightness <<< `cat /sys/class/backlight/acpi_video0/max_brightness`'

# shorthand to pull alias file into caller's terminal (rs $HOME= "re-source")
alias rs='echo "source $HOME/.bash_aliases" >> /tmp/rs.bash && chmod +x /tmp/rs.bash && . /tmp/rs.bash && rm /tmp/rs.bash '

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
alias cleanup='sudo trash-empty && autoclean && autoremove && rm -f $HOME/1 $HOME/.xsession-errors*'

# pull latest bashrc from server or restore prev
bashrc-down() { (cp -f $HOME/.bak/.bashrc $HOME/ && success "bashrc downgrade") || fail "bashrc downgrade" ; }
bashrc-up() {
  push $HOME
    del .bak/.bashrc
    mv -f .bashrc .bak
    ( \
      wget --timestamping --show-progress --progress=dot --timeout=5 http://raw.githubusercontent.com/entangledloops/config/master/linux/.bashrc && \
      success "bashrc upgrade"
    ) || (fail "bashrc upgrade" ; bashrc-down)
  pop
}

# pull latest bash_aliases from server or restore prev (this file)
alias-down() { (cp -f $HOME/.bak/.bash_aliases $HOME/ ; source $HOME/.bash_aliases && success "alias downgrade") || fail "alias downgrade" ; }
alias-up() {
  push $HOME
    del .bak/.bash_aliases
    mv -f .bash_aliases .bak
    ( \
      wget --timestamping --show-progress --progress=dot --timeout=5 http://raw.githubusercontent.com/entangledloops/config/master/linux/.bash_aliases && \
      source .bash_aliases && \
      success "alias upgrade"
    ) || (fail "alias upgrade" ; alias-down)
  pop
}


# pull latest vimrc from server or restore prev
vimrc-down() { (cp -f $HOME/.bak/.vimrc $HOME/ && success "vimrc downgrade") || fail "vimrc downgrade" ; }
vimrc-up() {
  push $HOME
    del .bak/.vimrc
    mv -f .vimrc .bak
    ( \
      wget --timestamping --show-progress --progress=dot --timeout=5 http://raw.githubusercontent.com/entangledloops/config/master/linux/.vimrc && \
      success "vimrc upgrade"
    ) || (fail "vimrc upgrade" ; vimrc-down)
  pop
}

# pull latest bashrc from server or restore prev
screenrc-down() { (cp -f $HOME/.bak/.screenrc $HOME/ && success "screenrc downgrade") || fail "screenrc downgrade" ; }
screenrc-up() {
  push $HOME
    del .bak/.screenrc
    mv -f .screenrc .bak
    ( \
      wget --timestamping --show-progress --progress=dot --timeout=5 http://raw.githubusercontent.com/entangledloops/config/master/linux/.screenrc && \
      success "screenrc upgrade"
    ) || (fail "screenrc upgrade" ; screenrc-down)
  pop
}

# pull latest vimrc and vim settings folder from server or restore prev
vim-down() { del $HOME/.vim >/dev/null 2&>1 ; cp -rf $HOME/.bak/.vim $HOME/ ; (vimrc-down && success "vim downgrade") || fail "vim downgrade" ; }
vim-up() {
  vimrc-up && \
  ( \
    push $HOME ; \
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
  )
}

# component update helpers
alias os-upgrade='sudo do-release-upgrade -d '
alias os-up='os-upgrade '
alias gui-update='sudo update-manager -d '
alias gupd='gui-update '
alias update='sudo apt update '
alias upd='update && success "update" || fail "update" '
alias upgrade='sudo apt upgrade -y '
alias upg='upgrade && success "upgrade" || fail "upgrade" '
alias config-up='alias-up && bashrc-up && vim-up && screenrc-up && rs '
alias dist-upgrade='sudo apt dist-upgrade -y '
alias dist-up='source <(sudo echo "dist-upgrade && sudo apt-file update && success \"dist upgrade\"") || fail "dist upgrade" '

# update/upgrade flavors
alias u='source <(sudo echo "upd && upg") '
alias uu='source <(sudo echo "u && dist-up") '
alias uuu='source <(sudo echo "config-up && uu") '

# version / system info
alias inodes='df -ih '
alias kernel='uname -r '
alias os='lsb_release -a '
alias os-version="echo $'kernel:\n\t$(kernel)\nos:\n\t$(os | awk -vRS="\n" -vORS="\n\t" '1')' "
alias disk="echo $'inodes:\n$(inodes | awk -vRS="\n" -vORS="\n\t" "1")\n\ndisk:\n$(df | awk -vRS="\n" -vORS="\n\t" "1")\n' "
alias vdisk='bg "gksu baobab /" '
alias mem='cat /proc/meminfo '
alias info="echo $'$(mem)\n$(disk)\n$(os-version)' "
alias packages='grep ^ /etc/apt/sources.list /etc/apt/sources.list.d/*'

# generate more entropy
alias random='sudo rngd -f -r /dev/urandom '

# generate a random filename
alias filename='cat /dev/urandom | tr -cd "a-f0-9" | head -c 32'

# locate hd memory sinks
alias space='sudo du -h --max-depth=1 | sort -hr | less '

# clear scrollback and recent output; annoying leading newline still printed
alias cls='clear && printf "\033c" '

# clear history and flush the copy in memory to prevent rewrite on exit
alias clear-history='cat /dev/null > $HOME/.bash_history && history -c && exit'

# shorthand for my favorite console editor
alias svim='sudo vim'
alias vimrc='vim $HOME/.vimrc'
alias vima='vim $HOME/.bash_aliases && rs'
alias vimx='vim $HOME/.bash_extra && rs'
alias vimscreenrc='vim $HOME/.screenrc'
alias vimbashrc='vim $HOME/.bashrc'
alias vimi3='vim $HOME/.config/i3/config'

# console editing; replace 'term-editor' target w/your favorite editor
alias edit='gui-editor '
alias sedit='sudo gui-editor '
alias edita='gui-editor $HOME/.bash_aliases && rs '

# gui editing; replace w/your facorite editor
alias guiedit='gui-editor '
alias guiedita='gui-editor $HOME/.bash_aliases && rs '

# personal preference for quick access to frequently modified files
alias v='vim '
alias vv='vimrc '
alias va='vima '
alias vs='vimscreenrc '
alias vb='vimbashrc '

# setup alias for "thefuck"
eval "$(thefuck -a)"

# helper for sublime text which requires extra steps for installation
install-sublime() {
    wget --show-progress --progress=dot - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add - && \
    echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list && \
    update && \
    install sublime-text
}

# core system utils that are good to have ready
setup-system() {
    install \
    linux-headers-$(uname -r) linux-headers-generic dkms lsb-core collectd-core \
    vim-gtk ssh socat xbindkeys xclip ntfs-3g exfat-fuse exfat-utils trash-cli \
    apt-file cups multitail strace wget gawk sed samba unrar tree p7zip-full \
    curl openssh-server ca-certificates apt-transport-https \
    software-properties-common gnupg-agent
}

# setup a development environment
setup-dev() {
    install \
    screen tmux build-essential gcc g++ gdb valgrind git git-gui cvs subversion \
    ant mercurial maven cmake cmake-qt-gui cmake-curses-gui autoconf libtool pkg-config \
    default-jdk python-dev python3-dev python3-pip python3-venv npm \
    meld tig silversearcher-ag thefuck \
    graphviz texlive-full && \
    curl -s "https://get.sdkman.io" | bash && \
    source $HOME/.sdkman/bin/sdkman-init.sh &&
    sdk install java && \
    sdk install kotlin
}

# useful utilities for system monitoring, networking, and other common tasks
setup-extras() {
    install \
    gparted htop iotop iftop glances dstat incron sysstat discus systemtap-sdt-dev baobab \
    nmap nmon mtr traceroute tcpdump ethtool ngrep aircrack-ng hydra cutycapt arp-scan \
    gconf-editor gimp audacity filezilla wireshark transmission-gtk vlc-nox vlc blender \
    deluge firefox chromium-browser flameshot
}

# command to prepare a new system
setup() {
    setup-system && \
    setup-dev && \
    setup-extras && \
    (echo "set vertical-split = no" >> $HOME/.tigrc) && \
    (mkdir $HOME/.ssh $HOME/.bak $HOME/src $HOME/bin $HOME/scripts ; config-up ; dist-up ; u) && \
    warn "the system should be rebooted after initial setup"
}

###############################################################################
# apps to launch in background
###############################################################################

alias gparted='bg "gksu gparted" '

alias wireshark='bg "wireshark" '

alias chkrootkit='sudo chkrootkit '
alias rkhunter='sudo rkhunter '
alias firefox='bg "firefox" '
alias chromium='bg "chromium-browser" '
alias chromium-browser='bg "chromium-browser" '
alias gitkraken='bg "gitkraken" '
alias transmission='bg "transmission-gtk" '
alias filezilla='bg "filezilla" '
alias idea='bg "idea" '
alias vlc='bg "vlc" '
alias audacity='bg "audacity" '
alias blender='bg "blender" '
alias gimp='bg "gimp" '

alias python='python3'
alias pip='python3 -m pip'
alias venv='python3 -m venv'
alias activate='source ./venv/bin/activate'

alias fix-ssh-add='eval `ssh-agent -s`'
alias fix-dbus='eval `dbus-launch`'

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
function finder_helper() { \find . -iname "$@" -readable -writable -prune -print ; }
alias finder='finder_helper '

# find from root filtering errors; don't forget double-quotes, e.g.: findall "*.txt"
function findall_helper() { \find / -iname "$@" 2>&1 | grep -v 'Permission denied' >&2 ; }
alias findall='findall_helper '

###############################################################################
# shorthands and convenient default params for other common tasks

# GNU screen integration
function screen_helper() { [ -z "$STY" ] && screen -RR -A -r "$@" || screen ; }
alias screen='screen_helper '

# git helpers
function gclone_helper() { git clone --verbose --recursive $@ ; }
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
  gfetch
  git branch -a | grep "\bremotes/origin/$1$" && \
  ( \
    [ $? -eq 0 ] &&
    ( \
      git show-ref --verify --quit refs/heads/$1 && \
      [ $? -eq 0 ] && git checkout "$@" ||  git checkout -b $1 origin/$1 "${@:2}" \
      ) \
  ) && \
  (gdiff && gpull ; success "checkout") || \
  fail "checkout"
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
if [ -e $HOME/.bash_extra ]; then
  source $HOME/.bash_extra
fi

###############################################################################
# env
###############################################################################

# include pwd in path
export JAVA_HOME=$(readlink -f /usr/bin/javac | sed "s:/bin/javac::")
export PATH=$PATH:$HOME/bin:$HOME/scripts:$JAVA_HOME:.

