# append to the history file, don't overwrite it
shopt -s histappend
# load results of history substitution into the readline editing buffer
shopt -s histverify
# don't put duplicate lines in the history
export HISTCONTROL=ignoredups:erasedups
# cycle through all matches with 'TAB' key
bind 'TAB:menu-complete'
# necessary for programmable completion
shopt -s extglob
#   ls *.jpg            # List all JPEG files
#   ls ?.jpg            # List JPEG files with 1 char names
#   rm [A-Z]*.jpg       # Remove JPEG files that start with a capital letter
#   ?(pattern-list)     Matches zero or one occurrence of the given patterns
#   *(pattern-list)     Matches zero or more occurrences of the given patterns
#   +(pattern-list)     Matches one or more occurrences of the given patterns
#   @(pattern-list)     Matches one of the given patterns
#   !(pattern-list)     Matches anything except one of the given patterns

# cd when inputting just a path
shopt -s autocd

alias ll='ls -AbFhlLX --group-directories-first'
alias grep='grep --color'
alias mkdir='mkdir -p -v'
alias cp='cp --preserve=all -v -R'

alias count='find . -type f | wc -l'
alias fbig="find . -size +128M -type f -printf '%s %p\n' | sort -nr"

alias df='df -Tha --total'
alias free='free -mt'
alias psa='ps auxf'

alias cls='clear'
alias :q='exit'
alias vi='nvim'
alias wget='wget -c'

# tar cvf - /path/to/folder | split -b 1G - output.tar.
# cat output.tar.* | tar xvf -
