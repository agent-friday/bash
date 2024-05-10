#!/bin/sh

HELP=0
FORCE=0
MAIN_BRANCH=$(git symbolic-ref /refs/remotes/origin/HEAD --short | sed 's@^origin/@@')
BRANCH=
  
function help() {
    echo "Usage: rebase [$MAIN_BRANCH]"
    echo ""
    echo "Rebase the current repository."
    echo "Without any arguments, the current branch is assumed to be the target"
    echo "and will run the command 'git rebase -i HEAD~COMMIT_COUNT', where"
    echo "COMMIT_COUNT is obtained via 'git rev-list $MAIN_BRANCH.. --count'"
    echo ""
    echo "Passing $MAIN_BRANCH as an argument will run the command"
    echo "'git rebase -i $MAIN_BRANCH'"
}

function getoptions() {
    LONGOPTS=help,force
    OPTIONS=hf

    PARSED=$(/usr/local/opt/gnu-getopt/bin/getopt --options=$OPTIONS --longoptions=$LONGOPTS --name "$0" -- "$@")

    eval set -- $PARSED

    while true; do
        case "$1" in
            -h|--help)
                HELP=1
                shift
                ;;
            -f|--force)
                FORCE=1
                shift
                ;;
            --)
                shift
                break;
                ;;
            *)
                echo "ERROR"
                exit 3
        esac
    done

    $BRANCH=$1
}
  
#############################################
# MAIN
#############################################

getoptions "$@"

REV_COUNT=$(git rev-list $MAIN_BRANCH.. --count)

if [[ $HELP -eq 1 ]]; then
    help
    exit 0
fi

if [[ -z $BRANCH ]]; then
    # Not rebasing form main branch
    if [[ $REV_COUNT -gt 1 ]]; then
        pull.sh .
        git rebase -i HEAD~$REV_COUNT
    else
        echo "Commit count: $REV_COUNT -- Nothing to do."
    fi
 
elif [[ $1 == $MAIN_BRANCH ]]; then
    # Rebasing from main branch
    if [[ $REV_COUNT -gt 1 && $FORCE -ne 1 ]]; then
        echo "There are $REV_COUNT commits to this branch. You should rebase the branch first."
    else
        echo "Rebaseing from $MAIN_BRANCH..."
        git rebase -i $MAIN_BRANCH
    fi
else
   help
fi
