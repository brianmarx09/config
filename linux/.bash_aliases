#!/bin/bash
#
# @author Stephen Dunn (snd)
# @since April 1, 2016
# @updated July 26, 2016
#
# Description:
# A minimal (useful) starting point for a Debian-based OS.
# Aliases common commands to cut down on verbosity.
#
# Add additional config to a "~/.bash_extra" file and it will be loaded last.
#
# Installation:
# 1) Backup current settings:
#    cp -f ~/.bash_aliases ~/.bash_aliases.bak
# 2) Copy this file to ~/.bash_aliases, e.g.:
#    cp -f ~/Downloads/.bash_aliases ~/.bash_aliases
# 3) To import new settings into current session:
#    source ~/.bash_aliases
# 4) You can now enter 'rs' to refresh your term from the file, and use
#    'upd', 'upg', 'u', etc. as defined below to keep up-to-date
#
# Notes:
# - ****** add any additional config to a "~/.bash_extra" file ******
# - change the default editors if you don't like/have vim + sublime
# - naturally, assumes no conflicts between your other aliases / bash settings
# - commands are listed in order of estimated utility to save you search time
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

# backup oath state
PATH_CACHE=$PATH

# clear path
unalias -a

# obtain default path settings from a standard location (trimming quotes)
export PATH=$(cat /etc/environment | tr -d '"')

# if path is empty, restore previous path settings
[[ -z "${PATH// }" ]] && export PATH=$PATH_CACHE

###############################################################################
# default apps
###############################################################################

export MY_TERM='lxterminal --geometry=160x40'
export MY_TERM_EDITOR='vim'
export MY_GUI_EDITOR='/usr/bin/subl'
export MY_FILE_MANAGER='pcmanfm'
export MY_DATE_FORMAT='%Y-%m-%d'

# the tested build of sublime text
export MY_SUBLIME='sublime-text_build-3126_amd64.deb'

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
# aliases
###############################################################################

# allow commands following sudo to be expanded for further aliases; bash man
alias source='source '
alias bash='bash '
alias sudo='sudo '
alias su='su '
alias gksudo='gksudo '
alias gksu='gksu '
alias nohup='nohup '
alias pushd='pushd '
alias popd='popd '
alias echo='echo '
alias printf='printf '
alias chmod='chmod '
alias chown='chown '
alias xargs='xargs '
alias grep='grep '
alias dpkg='dpkg '
alias cp='cp '
alias mv='mv '
alias scp='scp '
alias ssh='ssh '
alias git='git '
alias xmodmap='xmodmap '
alias xrandr='xrandr '

# shorthand to pull alias file into caller's terminal (rs ~= "re-source")
alias rs='echo "source ~/.bash_aliases" >> /tmp/rs.bash && chmod +x /tmp/rs.bash && . /tmp/rs.bash && rm /tmp/rs.bash '

# default terminal emulator
alias term='`$MY_TERM` '
alias sterm='`$MY_TERM --command="sudo -s"` '

# default editors (change these to your favorites)
alias term-editor='`$MY_TERM_EDITOR` '
alias gui-editor='`$MY_GUI_EDITOR` '

# default file manager
alias file-manager='`$MY_FILE_MANAGER` '

# system state
alias shutdown='shutdown -h now '
alias reboot='sudo reboot '

# root user on/off shorthands
alias root-enable='sudo passwd root ; sudo passwd -u root ' #>/dev/null 2>&1 ; sudo passwd -u root >/dev/null 2>&1'
alias root-disable='sudo passwd -l root '

# better default behaviors for standard utils
alias cd='push '
alias rm='rm --one-file-system --preserve-root '
alias date='date +$MY_DATE_FORMAT '
alias ls='ls -AhlsX --color=always '
alias lss='ls --sort=size '
alias less='less -R '
alias stat='stat -c "%a %n" * '

alias del='trash-put '
alias sdel='sudo trash-put '

# package management
alias list='dpkg --list '
alias list-kernels='list | grep linux-image- '
alias list-headers='list | grep linux-headers- '

# dpkg install/uninstall shorthands
alias dinstall='sudo dpkg -i '
alias dreinstall='sudo dpkf -r '
alias install='sudo apt-get -y install '
alias reinstall='install --reinstall '
alias uninstall='sudo apt-get remove '

# remove old linux kernel versions
alias clean='sudo apt-get clean '
alias autoclean='sudo apt-get autoclean '
alias autoremove='sudo apt-get autoremove '
alias purge='sudo apt-get -y purge '
alias purge-kernels='list | grep linux-image | cut -d " " -f 3 | sort -V | sed -n "/"`uname -r`"/q;p" | xargs sudo apt-get purge '
alias purge-configs='dpkg -l | grep "^rc" | cut -d " " -f 3 | xargs sudo apt-get purge '
alias cleanup='sudo trash-empty && autoclean && autoremove && rm -f ~/1 ~/.xsession-errors* '

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
alias dist-up='sudo source <(echo "dist-upgrade && apt-file update && config-up && success \"dist upgrade\"") || fail "dist upgrade" '

# update/upgrade flavors
alias u='sudo source <(echo "upd && upg") ' 
alias uu='sudo source <(echo "config-up && upd && dist-up && upg") '

# version / system info
alias inodes='df -ih '
alias kernel='uname -r '
alias os='lsb_release -a '
alias os-version="echo $'kernel:\n\t$(kernel)\nos:\n\t$(os | awk -vRS="\n" -vORS="\n\t" '1')' "
alias disk="echo $'inodes:\n$(inodes | awk -vRS="\n" -vORS="\n\t" '1')\n\ndisk:\n$(df | awk -vRS="\n" -vORS="\n\t" '1')\n$(sudo discus)' "
alias vdisk='bg "gksu baobab /" '
alias mem='cat /proc/meminfo '
alias info="echo $'$(mem)\n$(disk)\n$(os-version)' "

# locate hd memory sinks
alias space='du -h --max-depth=1 | sort -hr | less '

# clear scrollback and recent output; annoying leading newline still printed
alias cls='clear && echo -e \\033c '

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

# helper for sublime text which isn't in a repo currently
alias install-sublime='push /tmp ; \
  wget --show-progress --progress=dot https://download.sublimetext.com/$MY_SUBLIME && \
  dinstall $MY_SUBLIME && \
  rm -f $MY_SUBLIME >/dev/null 2>&1 &&
  success "sublime install" || \
  fail "sublime install" ; \
  pop '

# command to prepare a new system
alias setup='install \
  linux-headers-$(uname -r) linux-headers-generic dkms lsb-core xbindkeys \
  ntfs-3g exfat-fuse exfat-utils trash-cli apt-file multitail strace collectd-core gparted \
  vim ssh screen build-essential gcc g++ gdb valgrind python3 \
  cmake cmake-gui subversion cvs git mercurial wget \
  htop iotop iftop glances dstat incron sysstat discus systemtap-sdt-dev baobab \
  nmap nmon mtr traceroute tcpdump ethtool ngrep aircrack-ng \
  gimp audacity filezilla wireshark transmission-gtk && \
  if [[ ! -d ~/.bak ]] ; then mkdir ~/.bak ; fi && \
  (config-up; install-sublime; dist-up; u) && \
  warn "the system should be rebooted after first setup" '

alias setup-extras='install \
  atop '

###############################################################################
# apps to launch in background
###############################################################################

alias gparted='bg "gparted" '
alias sgparted='bg "gksu gparted" '

alias filezilla='bg "filezilla" '
alias sfilezilla='bg "gksu filezilla" '

alias wireshark='bg "wireshark" '
alias swireshark='bg "gksu wireshark" '

alias sublime='bg "subl" '
alias ssublime='bg "sudo subl"' # sublime needs sudo instead of gksu

alias transmission='bg "transmission-gtk" '
alias stransmission='bg "gksu transmission" '

###############################################################################
# shorthands for other tasks
###############################################################################

alias gfetch='git fetch --all --verbose '
alias gpull='gfetch && git merge --verbose '
alias gpush='git push --follow-tags --verbose '
alias glog='git log --full-diff --name-only --graph --full-history --no-merges --pretty=format:"%C(bold blue)%an%Creset, %C(yellow)%ar%Creset%n%Cgreen%H%Creset%n%B" '

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

# helper for locating docs
function help_helper() { man $@ || $@ --help 2>/dev/null || $@ -help 2>/dev/null || $@ --h 2>/dev/null || $@ -h 2>/dev/null || $@ -? 2>/dev/null || $@ --? 2>/dev/null || $@ /help 2>/dev/null || $@ /? 2>/dev/null || fail "help detect" ; }
alias help='help_helper '

# helper for version info
function version_output_helper() 
{ 
  $@ --version ; if [ $? -eq 0 ] ; then return 0; fi
  $@ -version ; if [ $? -eq 0 ] ; then return 0; fi
  $@ --v ; if [ $? -eq 0 ] ; then return 0; fi
  $@ -v ; if [ $? -eq 0 ] ; then return 0; fi
  $@ /version ; if [ $? -eq 0 ] ; then return 0; fi
  $@ /v ; if [ $? -eq 0 ] ; then return 0; fi
  return 1;
}
function version_helper() { version_output_helper $@ >/dev/null 2>&1 ; if [ $? -eq 0 ] ; then version_output_helper "$@" ; else fail "version detect" ; fi ; }
alias version='version_helper '

# basic system task wrappers
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

# find from pwd; don't forget double-quotes, e.g.: find "*.txt"
function find_helper() { \find . -iname "$@" -readable -writable -prune -print ; }
alias find='find_helper '

# find from root; don't forget double-quotes, e.g.: findall "*.txt"
function findall_helper() { \find / -iname "$@" 2>&1 | grep -v 'Permission denied' >&2 ; }
alias findall='findall_helper '

# greps the full package list for targets matching provided grep string
function listgrep() { dpkg -l | grep "$@" ; }

# OpenSSH -> SSH2 helper
function openssh_to_ssh2_helper() { ssh-keygen -e -f $@ > $@.ssh2 ; }
alias openssh-to-ssh2='openssh_to_ssh2_helper '

# SSH2 -> OpenSSH
function ssh2_to_openssh_helper() { ssh-keygen -i -f $@ > $@.openssh ; }
alias ssh2-to-openssh='ssh2_to_openssh_helper '

# GNU screen integration
function screen_helper() { if [ -z "$STY" ]; then screen -RR -A -r "$@" || screen; fi ; }
alias screen='screen_helper '

# git
function gbranch_helper() { gfetch && git branch -b $1 origin/$1 && git pull --verbose ; }
alias gbranch='gbranch_helper '

function gcheckout_helper() { gfetch && git checkout $1 --verbose && git diff --name-status HEAD@{1} HEAD && git pull --verbose ; }
alias gcheckout='gcheckout_helper '

function gcommit_helper() { git add -u && git commit -m "$@" --verbose ; }
alias gcommit='gcommit_helper '

# air-suite helpers
function aireplay_helper() { aireplay-ng --ignore-negative-one -0 2 -a $2 -c $3 $1; }
alias aireplay='aireplay_helper '

function aireplay_all_helper() { aireplay-ng --ignore-negative-one -0 0 -a $2 $1; }
alias aireplay-all='aireplay_all_helper '

function aircrack_helper() { aircrack-ng -w - -a 2 -e $1 -l $1.pwd $1*.cap; }
alias aircrack='aircrack_helper '

function aircrackq_helper() { aircrack-ng -q -w - -a 2 -e $1 -l $1.pwd $1*.*; }
alias aircrackq='aircrackq_helper '

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
export PATH=$PATH:.

