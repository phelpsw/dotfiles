# ls aliases
alias ll='ls -l'
alias la='ls -a'
alias ltr='ls -ltr'

function pass2() { PASSWORD_STORE_DIR=$HOME/.password-store-sec/ bash -c "pass $*"; }

