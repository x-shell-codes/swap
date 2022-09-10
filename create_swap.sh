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
  echo "create_swap version 1.0.0"
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
  echo "Set up a Linux swap area."
  echo
  echo "Options:"
  echo "-s | --size        Length for range operations, in Megabytes"
  echo "-p | --path        Swap file. (Default: /swapfile)"
  echo "-f | --force       If you already have swap, delete it and create it again."
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
size=0
path="/swapfile"
isForce=0

for i in "$@"; do
  case $i in
  -s=* | --size=*)
    size="${i#*=}"

    if ! [[ $size =~ ^[0-9]+$ ]]; then
      ErrorLine "Size must be a number."
      exit
    elif [ $size -le 0 ]; then
      ErrorLine "Size must be greater than zero."
      exit
    fi

    shift
    ;;
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
  -f | --force)
    isForce=1
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
# SwapSizeCalculate Function                                                                                           #
########################################################################################################################
function SwapSizeCalculate() {
  ramSize=$(free -m | awk 'NR==2{printf "%.2f", $2}')
  ramSize=${ramSize%.*}

  if [ $ramSize -lt 2048 ]; then
    swapSize=$((ramSize * 3))
  elif [ $ramSize -ge 2048 ] && [ $ramSize -lt 8192 ]; then
    swapSize=$((ramSize * 2))
  elif [ $ramSize -ge 8192 ] && [ $ramSize -lt 65536 ]; then
    swapSize=$(echo "$ramSize*1.5" | bc)
    swapSize=${swapSize%.*}
  elif [ $ramSize -ge 65536 ]; then
    swapSize=$ramSize
  fi

  echo $swapSize
}

########################################################################################################################
# Create Function                                                                                                      #
########################################################################################################################
function CreateSwap() {
  size=$1
  path=$2

  if [ $size -le 0 ]; then
    size=$(SwapSizeCalculate)
    InfoLine "Size is not specified. Calculating the size of the swap file. Size: $size MB"
  fi

  fallocate -l "$size"M "$path"
  chmod 600 "$path"
  mkswap "$path"
  swapon "$path"
  echo "$path none swap defaults 0 0" >>/etc/fstab
}

########################################################################################################################
# Remove Function                                                                                                      #
########################################################################################################################
function RemoveSwap() {
  path=$1

  if [ -f "remove_swap.sh" ]; then
    bash remove_swap.sh --path="$path"
  else
    wget https://raw.githubusercontent.com/x-shell-codes/swap/master/remove_swap.sh
    bash remove_swap.sh --path="$path"
    rm remove_swap.sh
  fi

  echo
}

########################################################################################################################
# Main Program                                                                                                         #
########################################################################################################################
echo "${POWDER_BLUE_LINE}${BRIGHT_LINE}${REVERSE_LINE}   CREATING SWAP   ${NORMAL_LINE}"

CheckRootUser

# Does the swap file already exist?
grep -q "$path none" /etc/fstab

# If not then create it.
if [ $? == 1 ]; then
  echo "$path not found. Adding $path."
  CreateSwap "$size" "$path"
elif [ $isForce -eq 1 ]; then
  RemoveSwap "$path"
  echo "Next step, adding swapfile."
  CreateSwap "$size" "$path"
else
  echo "$path found. No changes made."
fi

echo
InfoLine "--------------------------------------------"
InfoLine "Check whether the swap space created or not?"
InfoLine "--------------------------------------------"
swapon --show
