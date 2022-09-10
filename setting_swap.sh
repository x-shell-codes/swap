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
BLACK_LINE=$(tput setaf 0)
WHITE_LINE=$(tput setaf 7)
RED_LINE=$(tput setaf 1)
YELLOW_LINE=$(tput setaf 3)
GREEN_LINE=$(tput setaf 2)
BLUE_LINE=$(tput setaf 4)
POWDER_BLUE_LINE=$(tput setaf 153)
BRIGHT_LINE=$(tput bold)
REVERSE_LINE=$(tput smso)
UNDER_LINE=$(tput smul)

########################################################################################################################
# Version                                                                                                              #
########################################################################################################################
function Version() {
  echo "setting_swap version 1.0.0"
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
  echo "Setting Linux swap area."
  echo
  echo "Options:"
  echo "-s | --swappiness  vm.swappiness value. (Default: 10)"
  echo "-p | --pressure    vm.vfs_cache_pressure value. (Default: 50)"
  echo "-h | --help        Display this help."
  echo "-V | --version     Print software version and exit."
  echo
  echo "For more details see https://github.com/x-shell-codes/swap."
}

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
# Arguments Parsing                                                                                                    #
########################################################################################################################
swappiness=10
pressure=50

for i in "$@"; do
  case $i in
  -s=* | --swappiness=*)
    swappiness="${i#*=}"

    if ! [[ $swappiness =~ ^[0-9]+$ ]]; then
      ErrorLine "Swappiness must be a number."
      exit
    elif [ "$swappiness" -lt 0 ] || [ "$swappiness" -gt 100 ]; then
      ErrorLine "Swappiness must be between 0 and 100."
      exit
    fi

    shift
    ;;
  -p=* | --pressure=*)
    pressure="${i#*=}"

    if [ -z "$pressure" ]; then
      ErrorLine "Pressure must be a number."
      exit
    elif [ "$pressure" -lt 0 ] || [ "$pressure" -gt 100 ]; then
      ErrorLine "Pressure must be between 0 and 100."
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
echo "${POWDER_BLUE_LINE}${BRIGHT_LINE}${REVERSE_LINE}   SETTING SWAP   ${NORMAL_LINE}"

CheckRootUser

#
echo "${BLUE_LINE}${BRIGHT_LINE}INFO${BLUE_LINE}: vm.swappiness setting${BLUE_LINE}${NORMAL_LINE}"
sysctl vm.swappiness="$swappiness"
grep -q "vm.swappiness=" /etc/sysctl.conf
if [ $? == 1 ]; then
  echo "vm.swappiness=$swappiness" | sudo tee -a /etc/sysctl.conf
else
  sed -i "s/vm.swappiness=.*/vm.swappiness=$swappiness/g" /etc/sysctl.conf
fi

echo

echo "${BLUE_LINE}${BRIGHT_LINE}INFO${BLUE_LINE}: vm.vfs_cache_pressure setting${BLUE_LINE}${NORMAL_LINE}"
sysctl vm.vfs_cache_pressure="$pressure"
grep -q "vm.vfs_cache_pressure=" /etc/sysctl.conf
if [ $? == 1 ]; then
  echo "vm.vfs_cache_pressure=$pressure" | sudo tee -a /etc/sysctl.conf
else
  sed -i "s/vm.vfs_cache_pressure=.*/vm.vfs_cache_pressure=$pressure/g" /etc/sysctl.conf
fi
