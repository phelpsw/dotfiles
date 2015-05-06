# ls aliases
alias ll='ls -l'
alias la='ls -a'
alias ltr='ls -ltr'

alias sat='ssh -Y pwilliams@saturn'
alias zar='ssh -Y pwilliams@zarya'

# spacex stuff
alias sx='cd /sx/$HOSTNAME/pwilliams/'
alias lb='sx;cd load_builder'

alias windoze='rm ~/.rdesktop/licence.*; rdesktop -upwilliams -dSPACEX -g1600x1000 pwilliams-z464'

# Used to deactivate the default gnupg-agent which doesn't support smartcards on Mint 17.1
unset GPG_AGENT_INFO
