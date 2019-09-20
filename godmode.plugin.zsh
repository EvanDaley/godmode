###################################################################################################
## Git
###################################################################################################

# List all recent branches by name. Use the number in the lefthand column with the rec command.
# If you know any substring of the branch name, find it faster with rg().
function recent() {
    set -e
    bold=$(tput bold)
    normal=$(tput sgr0)

    git reflog -n200 --pretty='%cr|%gs' --grep-reflog='checkout: moving' HEAD | {
    seen=":"
    git_dir="$(git rev-parse --git-dir)"
    i=0
    while read line; do
        date="${line%%|*}"
        branch="${line##* }"
        if ! [[ $seen == *:"${branch}":* ]]; then
            seen="${seen}${branch}:"
            if [ -f "${git_dir}/refs/heads/${branch}" ]; then
                printf "%s  %-10.10s\t$bold%s$normal\n" "$i" "$date" "$branch"
                i=$((i+1))
            fi
        fi
    done
    printf "\n       Use the indices above to checkout any branch with \"rec \$index\"\n\n"
    }
}

# Switch to the nth most recent. The current branch is index 0. 
# List all recent branches and indices by typing "recent".
function rec() {
    set -e
    bold=$(tput bold)
    normal=$(tput sgr0)

    git reflog -n100 --pretty='%cr|%gs' --grep-reflog='checkout: moving' HEAD | {
    seen=":"
    i=0
    git_dir="$(git rev-parse --git-dir)"
    checked_out=""
    while read line; do
        date="${line%%|*}"
        branch="${line##* }"
        if ! [[ $seen == *:"${branch}":* ]]; then
            seen="${seen}${branch}:"
            if [ -f "${git_dir}/refs/heads/${branch}" ]; then
                if [ $i -eq $1 ]; then
                    checked_out="$branch"
                    git checkout $branch
                fi
                i=$((i+1))
            fi
        fi
    done
    printf "\nCurrent: $bold%s$normal\n\n" "$checked_out"
    }
}

# List all recent branches with a name including the given substring.
function rg() {
    recent | grep $1
}

# Create a new branch, naming it after the parameter.
function gchb() {
    git checkout -b "$1"
}

# Create a new branch, prefixed with 'feature'
function gchfb() {
    git checkout -b "feature/$1"
}

# Create a new branch, prefixed with 'hotfix'
function gchhb() {
    git checkout -b "hotfix/$1"
}

# Set the upstream origin of a branch. This is ideally used 
# rigth after gchb to push the new branch to the server.
function gsu() {
    currentBranch=$(git branch | grep \* | cut -d ' ' -f2);
    git push --set-upstream origin "$currentBranch"
}

# Jump between branches.
alias back="git checkout -"
alias gch="git checkout"
alias gf="git fetch --all -p"
alias gh="git push"
alias gc="git commit -m"

# Jump to popular branches.
alias master="git checkout master"
alias development="git checkout development"

# Warning - these are addicting.
alias wip="git add *; git commit -m 'Work in progress'; git"
alias si="git add *; git commit -m 'Small improvements'; git"

# Modifying branches and/or general cleanup. Be careful!
alias dot="git checkout .;"

# Remove local branches that have already been deleted from the server.
function gclean() {
    git fetch --all -p && git branch -v | grep ': gone]' | awk '{print $1}' | xargs git branch -d
}

# Same as above, but more aggressive. 
function gdclean() {
    git fetch --all -p && git branch -v | grep ': gone]' | awk '{print $1}' | xargs git branch -D
}

# Comparing branches
alias dif="git diff"
alias diff="git diff"
alias gbg="gb | grep "
alias ga="git add * "
alias gb="git branch -a"
alias gs="git status"
alias sense="git diff --stat master ."

# Merging popular branches
function mdev() {
    git checkout develop;
    git pull;
    back;
    git merge develop;
}

function mmaster() {
    git checkout master;
    git pull;
    back;
    git merge master;
}

###################################################################################################
## Window Management (Linux Only)
###################################################################################################

# Move any window to the foreground (ie. "foreground chrome")
function foreground() {
    wmctrl -xa $1
}

# An alias for foreground. Example usage: foreground chrome.
alias fg="foreground"

# Bring common apps to the foreground
alias ch="foreground chrome"
alias sl="foreground slack"
alias ph="foreground phpstorm"
alias te="foreground terminal"
alias sp="foreground spotify"
alias su="foreground sublime"

function google() {
    xdotool search --name -- '- Google Chrome' \
    windowactivate --sync key --window 0 --clearmodifiers \
    ctrl+t Return
    xdotool type "$1"
    xdotool key KP_Enter
}

## Paste the clipboard contents into a new Chrome tab and run the search.
function ge() {
    sleep .2
    xdotool search --name -- '- Google Chrome' \
    windowactivate --sync key --window 0 --clearmodifiers \
    ctrl+t Return
    xdotool key shift+Insert
    sleep .2
    xdotool key KP_Enter
}


###################################################################################################
## Navigation
###################################################################################################

alias cd..='cd ..' # Prevent command not found
alias ..='cd ..' #
alias ...='cd ../..' #
alias ....='cd ../../..' #
alias .....='cd ../../..' #
alias ......='cd ../../../..' #
alias .......='cd ../../../../..' #
alias .2='cd ../..' #
alias .3='cd ../../..' #
alias .4='cd ../../../..' #
alias .5='cd ../../../../..' #
alias .6='cd ../../../../../..' #
alias .7='cd ../../../../../../..' #

###################################################################################################
## Finding things
###################################################################################################

# Grep file $1 for pattern $2. Show $3 lines before, $4 lines after.
grepSearch() {
    echo "Searching $1 for $2. Displaying $3 lines before and $4 lines after.";
    cat $1 | grep -nm 10 -B $3 -A $4 "\b$2\b";
}

# Grep file $1 for pattern $2. Show 2 lines before, 10 lines after.
grepS() {
    grepSearch $1 $2 2 10;
}

grepHead() {
    grepSearch $1 $2 20 2;
}

grepTail() {
    grepSearch $1 $2 2 20;
}

# Searching for files or directories by name.
alias fd="find . -type d -name" # Find directory by name
alias ff="find . -type f -name" # Find file by name

# Grepping commmand history.
function hg() {
    history | grep "$1"
}

###################################################################################################
## Godmode meta.
###################################################################################################
alias gmedit="code ~/.oh-my-zsh/plugins/godmode/godmode.plugin.zsh"
alias gmreload="zsh"

echo \"God Mode Activated\"