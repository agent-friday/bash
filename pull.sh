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
  if [[ -d "$PROJ_HOME/$1" ]]; then
    echo "Updating \033[0;;31m$1\033[0m"
    cd "$PROJ_HOME/$1"
    printf "\033[1m;34m"
    git pull --rebase --autostash
    printf "\033[0m\033[1;37m"
    git gc
    echo "\033[0m"
  else
    echo "Chould not find directory $PROJ_HOME/$1"
  fi
}

# Pulls all repos listed in the $REPOS file
function pullAllRepos() {
  grep -v "^#" $REPOS | while IFS="" read -r p || [ -n "$p" ]
  do
    pullRepo "$p"
  done
}

function help() {
#      "01234567890123456789012345678901234567890123456789012345678901234567890123456789"
  echo "Usage: pull <repository>"
  echo ""
  echo "Pull an individual git repository or multiple repositories all at once."
  echo "All repositories are assumed to be located at '$PROJ_HOME/<repository>'"
  echo ""
  echo "Pulling multiple repositories at once can be achieved by calling `pull all`."
  echo "This will loop through a list of repositories stored in '$REPOS'; one per line."
  echo "Repositories can be skipped by prefixing them with a '#'"
  echo ""
}

#################################
# MAIN
#################################
REPO=$1

if [[ $REPO =~ ^-?h(elp)? ]]; then
    help
    exit 0
fi

checkProjHome
if [[ -n $REPO ]]; then
  if [[ $REPO == $ALL ]]; then
    checkReposFile
    pullAllRepos
  elif [[ $REPO == "." && $(pwd) =~ ^$PROJ_HOME ]]; then
    REPO=${PWD##*/}
    pullRepo "$REPO"
  elif [[ $REPO =~ [,:] ]]; then
    IFS=',:' read -ra REPO_LIST <<< $REPO
    for r in "${REPO_LIST[@]}"; do
        pullRepo "$r"
    done
  elif [[ -d "$PROJ_HOME/$REPO" ]]; then
    pullRepo "$REPO"
  elif [[ $REPO =~ ^--?l(ist)? ]]; then
    cat "$REPOS"
    exit
  else
    pullRepo "$REPO"
  fi
else
  help
fi
