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
  echo "swap version 1.0.0"
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
  echo "Create and setting Linux swap area."
  echo
  echo "Options:"
  echo "-l | --list        Display areas list."
  echo "-h | --help        Display this help."
  echo "-V | --version     Print software version and exit."
  echo
  echo "For more details see https://github.com/x-shell-codes/swap."
}

########################################################################################################################
# Arguments Parsing                                                                                                    #
########################################################################################################################
for i in "$@"; do
  case $i in
  -l | --list)
    swapon --show
    exit
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
# Create Function                                                                                                      #
########################################################################################################################
function Create() {
  if [ -f "create_swap.sh" ]; then
    bash create_swap.sh
  else
    wget https://raw.githubusercontent.com/x-shell-codes/swap/master/create_swap.sh
    bash create_swap.sh
    rm create_swap.sh
  fi
}

########################################################################################################################
# Setting Function                                                                                                     #
########################################################################################################################
function Setting() {
  if [ -f "setting_swap.sh" ]; then
    bash setting_swap.sh
  else
    wget https://raw.githubusercontent.com/x-shell-codes/swap/master/setting_swap.sh
    bash setting_swap.sh
    rm setting_swap.sh
  fi
}

########################################################################################################################
# Main Program                                                                                                         #
########################################################################################################################
echo "${POWDER_BLUE_LINE}${BRIGHT_LINE}${REVERSE_LINE}   CREATING & SETTING SWAP   ${NORMAL_LINE}"

CheckRootUser

export DEBIAN_FRONTEND=noninteractive

Create

echo

Setting
