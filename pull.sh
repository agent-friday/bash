#!/bin/sh

# Pull git repos either one at a time or all at once based on `$HOME/.repos`

# This is the home directory for all of the git repos
PROJ_HOME="$HOME/projects"

# This is the file that list every repo to pull when "all" is specified
# File format is one repo per line. Repos can be skipped by prefixing them
# with a '#'
REPOS="$HOME/.repos"

ALL="all"

# Checks to make sure $PROJ_HOME is a valid directory
function checkProjHome() {
  if [[ ! -d $PROJ_HOME ]]; then
    echo "Could not find project directory: $PROJ_HOME"
    exit
  fi
}

# Checks to make sure the file listing all of the repos exists
function checkReposFile() {
  if [[ ! -f $REPOS ]]; then
    echo "Could not fine repo list file: $REPOS"
    exit
  fi
}

# Pulls an individual repo
function pullRepo() {
  echo "Updating \033[0;;31m$1\033[0m"
  cd "$PROJ_HOME/$1"
  printf "\033[1m;34m"
  git pull --rebase --autostash
  printf "\033[0m\033[1;37m"
  git gc
  echo "\033[0m"
}

# Pulls all repos listed in the $REPOS file
function pullAllRepos() {
  grep -v "^#" $REPOS | while IFS="" read -r p || [ -n "$p" ]
  do
    pullRepo "$p"
  done
}

#################################
# MAIN
#################################
REPO=$1
checkProjHome
if [[ -n $REPO ]]; then
  if [[ $REPO == $ALL ]]; then
    checkReposFile
    pullAllRepos
  elif [[ -d "$PROJ_HOME/$REPO" ]]; then
    pullRepo "$REPO"
  else
    echo "Chould not fine directory: $PROJ_HOME/$REPO"
  fi
fi
