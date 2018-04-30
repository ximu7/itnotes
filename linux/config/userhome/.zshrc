# Levin zsh config

# ***** display *****

# zsh theme
ZSH_THEME="random"
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# innerip
innerip=`ip addr | grep -o -P '1[^2][0-9?](\.[0-9]{1,3}){3}(?=\/)'`
gateway=`ip route | grep 'via' |cut -d ' ' -f 3`
echo -e "\e[1m `uname -srm`\e[0m  \nGATEWAY:\e[1;32m$gateway\e[0m <-- IP:\e[1;35m$innerip\e[0m \n \e[1;36m `date` \e[0m"

# ***** enviroment settings *****

# Language environment
#export LANG=zh_CN.UTF-8
# export LANG=en_US.UTF-8

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=/usr/share/oh-my-zsh

# yarn
export PATH="$PATH:`yarn global bin`"

# Uncomment the following line to use case-sensitive completion.
#CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# time stamp in history command output
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="mm/dd/yyyy"

# plugins can be found in ~/.oh-my-zsh/plugins/*
plugins=(archlinux git python node)

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# ***** aliases *****
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# ---disk---
# trim for ssd
alias trim='sudo fstrim -v /home && sudo fstrim -v /'

# mount
alias win='sudo ntfs-3g /dev/sda4 /mnt/windows'

# ---power---
alias hs='systemctl hybrid-sleep'
alias hn='systemctl hibernate'
alias sp='systemctl suspend'
alias pf='systemctl poweroff'

alias powertopauto='sudo powertop --auto-tune'

# tlp
alias tlpbat='sudo tlp bat'
alias tlpac='sudo tlp ac'
alias tlpcputemp='sudo tlp-stat -t'

# battery
alias batsate='cat /sys/class/power_supply/BAT0/capacity'

# ---CPU---
alias cpuwatch='watch cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq'

# intel_pstate
alias powersave='sudo cpupower frequency-set -g powersave'
alias performance='sudo cpupower frequency-set -g performance'

# ----GPU---
alias nvidiaoff='sudo tee /proc/acpi/bbswitch <<<OFF'
alias nvidiaon='sudo tee /proc/acpi/bbswitch <<<ON'
alias nvidiasettings='sudo optirun -b none nvidia-settings -c :8'

# ---audio---
# beep
alias beep='sudo rmmod pcspkr && sudo echo "blacklist pcspkr" > /etc/modprobe.d/nobeep.conf'

# ---wireless---

#bluetooth
alias bluetoothon='sudo systemctl start bluetooth'
alias bluetoothoff='sudo systemctl stop bluetooth'

# ---print---
alias printer='sudo systemctl start org.cups.cupsd.service'

# atd
alias atd='systemctl start atd'

# tree
alias tree='tree -C -L 1 --dirsfirst'

# ===system===

# Arch
alias up='pacman -Syu && trizen -Syua'
alias pacman='sudo pacman'

# temporary locale
alias x='export LANG=en_US.UTF-8 LC_CTYPE=en_US.UTF-8 LC_MESSAGES=en_US.UTF-8 && startx'
alias xtc='export LANG=zh_TW.UTF-8 LC_CTYPE=zh_TW.UTF-8 LC_MESSAGES=zh_TW.UTF-8 && startx'
alias xsc='export LANG=zh_CN.UTF-8 LC_CTYPE=zh_CN.UTF-8 LC_MESSAGES=zh_CN.UTF-8 && startx'
alias cn='export LANG=zh_CN.UTF-8 LC_CTYPE=zh_CN.UTF-8 LC_MESSAGES=zh_CN.UTF-8'
alias en='export LANGUAGE=en_US.UTF-8'

# file operation
alias ls='ls --color=auto'
alias rm='mv -f --target-directory=/home/levin/.local/share/Trash/files/'
alias ll='ls -lh'
alias la='ls -lah'
alias cp='cp -i'
alias grep='grep --color'

# ===other alias===

# --- network---

# ip
# innerip-a:10.0.0.0-10.255.255.255 b:172.16.0.0-172.31.255.255 c:192.168.0.0-192.168.255.255
alias innerip="ip addr |grep 'inet 1[^2][0-9?]' |sed 's/inet //' |sed 's/\/.*//'| grep '[0-9.]' --color"

# lnmp
alias lnmp='sudo systemctl start nginx mariadb php-fpm'
alias relnmp='sudo systemctl restart nginx mariadb php-fpm'
alias stoplnmp='sudo systemctl stop nginx mariadb php-fpm'
alias np='sudo systemctl start nginx php-fpm'
alias renp='sudo systemctl restart nginx php-fpm'
alias stopnp='sudo systemctl stop nginx php-fpm'

# lamp
alias lamp='sudo systemctl start httpd mariadb'
alias relamp='sudo systemctl restart httpd mariadb'
alias stoplamp='sudo systemctl stop httpd mariadb'

# update hosts
alias hosts='sudo curl -# -L -o /etc/hosts https://raw.githubusercontent.com/googlehosts/hosts/master/hosts-files/hosts'

# shadowsocks 1080
alias ssstart='sudo systemctl start shadowsocks@ss'
alias ssstop='sudo systemctl stop shadowsocks@ss'
alias ssrestart='sudo systemctl restart shadowsocks@ss'

# privoxy 8010
alias privoxystart='sudo systemctl start privoxy'
alias privoxyrestart='sudo systemctl restar privoxy'
alias privoxyrestop='sudo systemctl stop privoxy'

#proxychains
alias pc='proxychains'

# iconv -f GBK -t UTF-8 filename > newfilename
alias iconvgbk='iconv -f GBK -t UTF-8' 
# convmv -f GBK -T UTF-8 --notest --nosmart filename
alias convmvgbk='convmv -f GBK -T UTF-8 --notest --nosmart'

#teamviwer
alias tvstart='sudo systemctl start teamviewerd.service'

#docker
alias dockerstart='sudo systemctl start docker'

# youdao dict 有道词典
alias yd='ydcv'

# you-get
alias play='you-get -p mpv'

#--for fun--
# cmatrix
alias matrix='cmatrix'

# starwar
alias starwar='telnet towel.blinkenlights.nl'

# quarium
alias quarium='asciiquarium'

alias yaourt='echo -e "please use \e[1mtrizen"'

alias virt='sudo modprobe virtio && sudo systemctl start libvirtd' 
alias sshstart='sudo systemctl start sshd'

# *****
ZSH_CACHE_DIR=$HOME/.oh-my-zsh-cache
if [[ ! -d $ZSH_CACHE_DIR ]]; then
  mkdir $ZSH_CACHE_DIR
fi

source $ZSH/oh-my-zsh.sh
