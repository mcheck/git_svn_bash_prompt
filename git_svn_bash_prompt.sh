#!/bin/bash
#
# Set our bash prompt according to:
#  * the branch/status of the current git repository
#  * the branch of the current subversion repository
#  * the return value of the previous command
# 
# Originally based on http://gist.github.com/31934
#
# Scott Woods <scott@westarete.com>
# West Arete Computing

# The various escape codes that we can use to color our prompt.
        RED="\[\033[0;31m\]"
     YELLOW="\[\033[0;33m\]"
      GREEN="\[\033[0;32m\]"
       BLUE="\[\033[0;34m\]"
  LIGHT_RED="\[\033[1;31m\]"
LIGHT_GREEN="\[\033[1;32m\]"
      WHITE="\[\033[1;37m\]"
 LIGHT_GRAY="\[\033[0;37m\]"
 COLOR_NONE="\[\e[0m\]"

# Detect whether the current directory is a git repository.
function is_git_repository {
  git branch > /dev/null 2>&1
}

# Detect whether the current directory is a subversion repository.
function is_svn_repository {
  test -d .svn
}

# Determine the branch/state information for this git repository.
function parse_git_branch {
  # Capture the output of the "git status" command.
  git_status="$(git status 2> /dev/null)"

  # Set color based on clean/staged/dirty.
  if [[ ${git_status} =~ "working directory clean" ]]; then
    state="${GREEN}"
  elif [[ ${git_status} =~ "Changes to be committed" ]]; then
    state="${YELLOW}"
  else
    state="${RED}"
  fi
  
  # Set arrow icon based on status against remote.
  remote_pattern="# Your branch is (.*) of"
  if [[ ${git_status} =~ ${remote_pattern} ]]; then
    if [[ ${BASH_REMATCH[1]} == "ahead" ]]; then
      remote="↑"
    else
      remote="↓"
    fi
  fi
  diverge_pattern="# Your branch and (.*) have diverged"
  if [[ ${git_status} =~ ${diverge_pattern} ]]; then
    remote="↕"
  fi
  
  # Get the name of the branch.
  branch_pattern="^# On branch ([^${IFS}]*)"    
  if [[ ${git_status} =~ ${branch_pattern} ]]; then
    branch=${BASH_REMATCH[1]}
  fi

  # Return the prompt.
  echo "${state}(${branch})${remote}${COLOR_NONE} "
}

# Determine the branch information for this subversion repository.
function parse_svn_branch {
  # Capture the output of the "git status" command.
  svn_info="$(svn info | egrep '^URL: ' 2> /dev/null)"

  # Get the name of the branch.
  branch_pattern="^URL: .*/(branches|tags)/([^/]+)"
  trunk_pattern="^URL: .*/trunk(/.*)?$"
  if [[ ${svn_info} =~ $branch_pattern ]]; then
    branch=${BASH_REMATCH[2]}
  elif [[ ${svn_info} =~ $trunk_pattern ]]; then
    branch='trunk'
  fi

  # Return the prompt.
  echo "(${branch}) "
}

# Return the prompt symbol to use, colorized based on the return value of the
# previous command.
function prompt_symbol () {
  if test $1 -eq 0 ; then
      echo "\$"
  else
      echo "${RED}\$${COLOR_NONE}"
  fi
}

# Set the full prompt.
function prompt_func () {
  last_return_value=$?
  if is_git_repository ; then
    branch="$(parse_git_branch)"
  elif is_svn_repository ; then
    branch="$(parse_svn_branch)"
  else
    branch=''
  fi
  PS1="\u@\h \w $branch$(prompt_symbol $last_return_value) "
}

PROMPT_COMMAND=prompt_func