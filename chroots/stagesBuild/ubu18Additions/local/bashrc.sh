echo "/local/bashrc.sh loaded"

### general
mybash="/local/bashrc.sh"
alias realias='source $mybash'
alias vialias='sudo vi $mybash ; realias'


### color
source /local/bashrc_colors
#promt
PS1="\[$txtblu\]\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\u@\h:\w\$\[$txtrst\] "
if [ `whoami` == root ]
then
PS1="\[$txtblu\]\[\e]0;\u@\h: \w\a\][CONT]\[$txtred\]${debian_chroot:+($debian_chroot)}\u@\[$txtblu\]\h:\w\$\[$txtrst\] "
else
PS1="\[$txtblu\]\[\e]0;\u@\h: \w\a\][CONT]\[$txtylw\]${debian_chroot:+($debian_chroot)}\u@\[$txtblu\]\h:\w\$\[$txtrst\] "
fi

### common alises
alias cc='clear'
alias xx='/local/exit.sh ; exit'


#################################################################
###############  PRJECT : XXXXXXXXXXXX   ########################
#################################################################


