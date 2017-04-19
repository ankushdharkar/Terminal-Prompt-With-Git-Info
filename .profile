# https://bytebaker.com/2012/01/09/show-git-information-in-your-prompt/

git_branch_name() {
  resCmd=$(git symbolic-ref HEAD 2>/dev/null | awk -F/ {'print $NF'})
  echo $resCmd
}
#export PS1='$(git_branch_name) >'


git_dirty_check() {
  res=$(git status 2>/dev/null | tail -n 1)

  if [[ $res != "nothing to commit, working directory clean" ]]
  then
    echo " *"
  fi
}

# export PS1='$(git_dirty_check) >'

git_unpushed(){
  brinfo=$(git branch -v | grep "^\*.*"$(git_branch_name)".*$")
 
  if [[ $brinfo =~ ("[ahead "([[:digit:]]*)]) ]]
  then
    echo " ahead[${BASH_REMATCH[2]}]"

  elif [[ $brinfo =~ ("[behind "([[:digit:]]*)]) ]]
  then
    echo " behind[${BASH_REMATCH[2]}]"
  fi
}

gitify() {
  if [ -d .git ]
  then
    echo " ( $(git_branch_name)$(git_dirty_check)$(git_unpushed) ) "
  fi
}

#export PS1='$(gitify) >'

make_prompt()
{
  LINE_NUM='\!'
  COLOR_DEFAULT='\[\033[0m\]'
  
  BLUE='\[\033[1;34m\]'

  RED='\[\033[0;31m\]'
  PURPLE='\[\033[1;35m\]'

  GREEN='\[\033[0;32m\]'
  LIGHT_GRAY='\[\033[0;37m\]'
  CYAN='\[\033[0;36m\]'

  echo "${BLUE}${LINE_NUM}${COLOR_DEFAULT}:${PURPLE} \W${CYAN}"'$(gitify)'"${RED}\$${COLOR_DEFAULT}"
  # echo "\h \w\ \W \u"
}


export PS1=$(make_prompt)