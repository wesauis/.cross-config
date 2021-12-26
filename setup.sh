#!/bin/bash

set -e
shopt -s expand_aliases # enable aliases

#
#   Log Setup
#


RED=$(printf '\033[31m')
GREEN=$(printf '\033[32m')
YELLOW=$(printf '\033[33m')
CYAN=$(printf '\033[36m')
BOLD=$(printf '\033[1m')
RESET=$(printf '\033[m')
DIMMED=$(printf '\033[30;1m')

log() { 
    if [[ ! -z $TASKNAME ]];
    then 
        prefix="[$TASKNAME]$RESET "
    else
        prefix=''
    fi

    case $1 in 
        info) color=$CYAN ;;
        warn) color=$YELLOW ;;
        error) color=$RED$BOLD ;;
        *) color=''
    esac

    if [[ $color != '' ]];
    then 
        shift
    fi

    printf '\033[K'
    echo "$color$prefix$@$RESET" 
}

# especial characters work, i love it :)
alias info?='log info'
alias warn?='log warn'
alias error?='log error'
dim() {
    echo -n $DIMMED$@$RESET
}

wait_job() {
    pid=$!

    frame=0
   
    B=$(printf '\033[47;1m')
    R=$(printf '\033[m')
    
    frames=(
        "$B $R" 
        "  $B  $R" 
        "    $B  $R" 
        "      $B    $R" 
        "          $B     $R" 
        "              $B        $R" 
        "                    $B     $R" 
        "                         $B    $R" 
        "                             $B  $R" 
        "                               $B $R" 
    )

    while [[ $(ps --pid $pid | wc -l) > 1 ]]; do
        printf "\033[K${frames[$frame]}\r"

        frame=$((($frame + 1) % ${#frames[@]}))
        sleep .1;
    done
}

logfile=$(mktemp /tmp/cross-config-XXXXXXXX.log)
echo ''>$logfile

#
#   Setup
#

if [[ ! -f $(basename $0) ]];
then
    error? be sure to run this script from the directory it is in 
    exit 1
fi

INSTALL_DIR="$HOME/.cross-config"
if [[ $PWD != $INSTALL_DIR ]];
then
    error? this repository must be cloned to:
    error? '    '$INSTALL_DIR
    exit 1
fi

info? debug log will be avaliable at
log '    '$logfile

info? waiting for sudo login
sudo echo >$logfile

info? updating package cache...
sudo apt update 2>>$logfile 1>&2 &
wait_job

info? upgrading packages...
sudo apt upgrade -y 2>>$logfile 1>&2 &
wait_job

setup_scripts=$(realpath ./setup)
for setup_script in $setup_scripts/*.sh; do
    filename=$(basename $setup_script)
    taskname="${filename/.sh/}"

    TASKNAME= info? setting up $taskname
    chmod u+x $setup_script
    TASKNAME="setup/$taskname" source "$setup_script"
done

exec zsh
