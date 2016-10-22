# ls aliases
alias ll='ls -l'
alias la='ls -a'
alias ltr='ls -ltr'

alias sar='ssh pwilliams@quasar'
alias per='ssh -Y pwilliams@supernova'

function pass2() { PASSWORD_STORE_DIR=$HOME/.password-store-sec/ bash -c "pass $*"; }

