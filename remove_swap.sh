#!/bin/bash

########################################################################################################################
# Find Us                                                                                                              #
# Author: Mehmet ÖĞMEN                                                                                                 #
# Web   : https://x-shell.codes/scripts/swap                                                                           #
# Email : mailto:swap.script@x-shell.codes                                                                             #
# GitHub: https://github.com/x-shell-codes/swap                                                                        #
########################################################################################################################
# Contact The Developer:                                                                                               #
# https://www.mehmetogmen.com.tr - mailto:www@mehmetogmen.com.tr                                                       #
########################################################################################################################

########################################################################################################################
# Constants                                                                                                            #
########################################################################################################################
NORMAL_LINE=$(tput sgr0)
RED_LINE=$(tput setaf 1)
YELLOW_LINE=$(tput setaf 3)
GREEN_LINE=$(tput setaf 2)
BLUE_LINE=$(tput setaf 4)
POWDER_BLUE_LINE=$(tput setaf 153)
BRIGHT_LINE=$(tput bold)
REVERSE_LINE=$(tput smso)
UNDER_LINE=$(tput smul)

########################################################################################################################
# Line Helper Functions                                                                                                #
########################################################################################################################
function ErrorLine() {
  echo "${RED_LINE}$1${NORMAL_LINE}"
}

function WarningLine() {
  echo "${YELLOW_LINE}$1${NORMAL_LINE}"
}

function SuccessLine() {
  echo "${GREEN_LINE}$1${NORMAL_LINE}"
}

function InfoLine() {
  echo "${BLUE_LINE}$1${NORMAL_LINE}"
}

########################################################################################################################
# Version                                                                                                              #
########################################################################################################################
function Version() {
  echo "remove_swap version 1.0.0"
  echo
  echo "${BRIGHT_LINE}${UNDER_LINE}Find Us${NORMAL}"
  echo "${BRIGHT_LINE}Author${NORMAL}: Mehmet ÖĞMEN"
  echo "${BRIGHT_LINE}Web${NORMAL}   : https://x-shell.codes/scripts/swap"
  echo "${BRIGHT_LINE}Email${NORMAL} : mailto:swap.script@x-shell.codes"
  echo "${BRIGHT_LINE}GitHub${NORMAL}: https://github.com/x-shell-codes/swap"
}

########################################################################################################################
# Help                                                                                                                 #
########################################################################################################################
function Help() {
  echo "Removing Linux swap area."
  echo
  echo "Options:"
  echo "-p | --path        Swap file. (Default: /swapfile)"
  echo "-h | --help        Display this help."
  echo "-V | --version     Print software version and exit."
  echo
  echo "For more details see https://github.com/x-shell-codes/swap."
}

########################################################################################################################
# Arguments Parsing                                                                                                    #
########################################################################################################################
path="/swapfile"

for i in "$@"; do
  case $i in
  -p=* | --path=*)
    path="${i#*=}"

    if [ -z "$path" ]; then
      ErrorLine "Path cannot be empty."
      exit
    elif [[ $path != /* ]]; then
      ErrorLine "Path must be absolute."
      exit
    fi

    shift
    ;;
  -h | --help)
    Help
    exit
    ;;
  -V | --version)
    Version
    exit
    ;;
  -* | --*)
    ErrorLine "Unexpected option: $1"
    echo
    echo "Help:"
    Help
    exit
    ;;
  esac
done

########################################################################################################################
# CheckRootUser Function                                                                                               #
########################################################################################################################
function CheckRootUser() {
  if [ "$(whoami)" != root ]; then
    ErrorLine "You need to run the script as user root or add sudo before command."
    exit 1
  fi
}

########################################################################################################################
# Main Program                                                                                                         #
########################################################################################################################
echo "${POWDER_BLUE_LINE}${BRIGHT_LINE}${REVERSE_LINE}   REMOVE SWAP   ${NORMAL_LINE}"

CheckRootUser

export DEBIAN_FRONTEND=noninteractive

# Does the swap file already exist?
grep -q "$path none" /etc/fstab

# If it does then remove it.
if [ $? -eq 0 ]; then
  echo "$path found. Removing $path."
  sed -i "$path none/d" /etc/fstab
  echo "3" >/proc/sys/vm/drop_caches
  swapoff -a
  rm -f "$path"
  swapon -a
else
  echo "No $path found. No changes made."
fi

echo
InfoLine "--------------------------------------------"
InfoLine "Check whether the swap space removed or not?"
InfoLine "--------------------------------------------"
swapon --show
