#!/bin/bash

##########################################################
## This script facilitates the installation and setup of
## the YTMP3-JS module, a tool for downloading and converting
## YouTube videos to MP3. The script is compatible with
## Unix-like environments and may require additional tools
## like MinGW TTY or Windows Subsystem for Linux (WSL) on
## Windows systems.
##
## Features:
## 1. Detects the operating system to determine the appropriate
##    installation method.
## 2. Checks if Node.js is installed and installs it if necessary,
##    ensuring compatibility by supporting version 16 or newer.
## 3. Supports different package managers:
##    - For Unix-like systems, uses `apt-get`.
##    - For Windows, attempts to use `Chocolatey` if `apt-get` is not available.
## 4. Installs the YTMP3-JS module globally using npm.
## 5. Provides a dry run option (`--dry-run`) for testing purposes,
##    which simulates the steps without making any actual changes.
##
## Requirements:
## - Node.js version 16 or latest along with npm should be available on the system.
## - Sufficient permissions to install packages and make system changes.
##
## Usage:
## - Run the script directly in a Unix-like environment.
## - For Windows, run within a MinGW or WSL shell.
##
## Author: Ryuu Mitsuki (https://github.com/mitsuki31)
## Project: YTMP3 Setup <https://github.com/mitsuki31/ytmp3-setup>
## License: MIT License (c) 2024 Ryuu Mitsuki
##########################################################

SYSNAME=
HAS_NODE_INSTALLED=0
DRY_RUN=

_() { printf "\e[33m%s\e[0m: $@\n" "ytmp3-setup" && return 0 ; }
^() { [ $DRY_RUN ] && printf "> $@\n" ; return 0 ; }

get_sysname() {
  case "$(uname)" in
    Linux|Darwin) SYSNAME='posix'  ;;
    Msys|Cygwin)  SYSNAME='win32'  ;;
  esac
}

install_node() {
  if [ $SYSNAME = 'posix' ]; then
    _ "Installing node using \`apt\` command ..."
    ^ 'apt-get install nodejs -y'  # dry run
    [ $DRY_RUN ] || apt-get install nodejs -y
  else
    # Check for availability of apt package manager
    # if unavailable, then attempt to use with Chocolatey
    if command -v apt > /dev/null 2>&1; then
      _ "Installing node using \`apt\` command ..."
      ^ 'apt-get install nodejs -y'
      [ $DRY_RUN ] || apt-get install nodejs -y
    elif command -v choco > /dev/null 2>&1; then
      _ "Installing node using \`choco\` command ..."
      ^ 'choco install nodejs -y'
      [ $DRY_RUN ] || choco install nodejs -y
    else
      _ "\e[91m[ERR]\e[0m Sorry, we cannot determine package manager on your system"
      printf "Tip: You can install Node.js manually from <\e[4mhttps://nodejs.org\e[0m>"
      exit 1
    fi
  fi
  local install_err=$?
  if [ ! $DRY_RUN ]; then
    [ $install_err -eq 0 ] && _ "Node.js $(node --version) has been installed" \
      || _ "\e[91m[ERR]\e[0m An error occurred during installation"
  fi
  return $install_err
}

check_node() {
  _ "Checking node package ..."
  ^ 'command -v node > /dev/null 2>&1'  # dry run
  [ $DRY_RUN ] || command -v node > /dev/null 2>&1
  HAS_NODE_INSTALLED=$([ $? -eq 0 ] && echo 1 || echo 0)

  if [ $HAS_NODE_INSTALLED -eq 1 ]; then
    _ "Verifying the node version ..."
    if [ $DRY_RUN ]; then
      ^ "node --print \"process.versions.node.split('.')[0]\" 2> /dev/null"  # dry run
    else
      # For better compatibility, retrieve the node version using node process itself
      local node_ver=$(node --print "process.versions.node.split('.')[0]" 2> /dev/null || 0)
      if [ $node_ver -lt 16 ]; then
        local install_latest=
        _ "\e[91m[ERR]\e[0m Not supported Node.js version 15.x and older"
        printf "\e[95m[?]\e[0m Do you want to install the latest version of Node.js? \e[1m[Y/n]\e[0m: "
        read install_latest
        if [ $install_latest ]; then
          case "$install_latest" in
            y|Y|yes|Yes|YES) install_latest=y  ;;
            n|N|no|No|NO)    install_latest=n  ;;
            *)
              _ "\e[91m[ERR]\e[0m Invalid value: $install_latest"
              exit 1
            ;;
          esac
        else
          # Default to 'yes' if not specified any value
          install_latest=y
        fi
        [ $install_latest = 'y' ] \
          && install_node \
          || printf "\e[95m[Tip]\e[0m You can install manually from <\e[4mhttps://nodejs.org\e[0m>\n"
      fi
    fi
  else
    # Install Node.js if not installed yet
    install_node
  fi
  return 0
}

install_ytmp3() {
  check_node
  [ $? ] || return 1  # Return if an error occurred

  _ "Checking ytmp3-js module in npm installed packages ..."
  if [ $DRY_RUN ]; then
    ^ "npm list --global | grep -oG 'ytmp3-js@'"
    _ "Installing latest YTMP3-JS module from registry ..."
    ^ 'npm install --global ytmp3-js@latest'
  else
    if [ "$(npm list --global | grep -oG 'ytmp3-js@')" ]; then
      _ "ytmp3 module has been installed previously"
    else
      _ "Installing latest YTMP3-JS module from registry ..."
      npm install --global ytmp3-js@latest
    
      [ $? -eq 0 ] && _ "ytmp3-js module has successfully installed" \
        || _ "\e[91m[ERR]\e[0m An error occurred during installation" && return 1
    fi
    printf "\e[95m[Tip]\e[0m Use \`ytmp3\` command to run the module, or \`ytmp3 -?\` for help\n"
  fi
  return 0
}

~main() {
  case "$1" in
    -n|--dry|--dry-run) DRY_RUN=1  ;;  # Enable dry run, for debugging
  esac

  get_sysname
  install_ytmp3
}

~main $@  # Pass all command-line arguments

# Undefine unnecessary variables
unset _ ^
unset ~main check_node install_node get_sysname install_ytmp3
unset HAS_NODE_INSTALLED DRY_RUN SYSNAME
