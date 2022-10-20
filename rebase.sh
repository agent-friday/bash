#!/bin/sh

MAIN_BRANCH=main
REV_COUNT=$(git rev-list $MAIN_BRANCH.. --count)
  
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
  
#############################################
# MAIN
#############################################
  
if [[ -z $1 ]]; then
    # Not rebasing form main branch
    if [[ $REV_COUNT -gt 1 ]]; then
        git rebase -i HEAD~$REV_COUNT
    else
        echo "Commit count: $REV_COUNT -- Nothing to do."
    fi
 
elif [[ $1 == $MAIN_BRANCH ]]; then
    # Rebasing from main branch
    if [[ $REV_COUNT -gt 1 ]]; then
        echo "There are $REV_COUNT commits to this branch. You should rebase the branch first."
    else
        echo "Rebaseing from $MAIN_BRANCH..."
        git rebase -i $MAIN_BRANCH
    fi
else
   help
fi
