## All alias entries should be in here.
#alias src='. $HOME/.bash_aliases;. $HOME/.bash_functions;. $HOME/.bash_local;. $HOME/.ltm_functions.bash'

# convenience aliases
alias ls='ls --color=always'
alias ll='ls -l --color=always'
alias l1='ls -1'
alias lh='ls -lh --color=always'
alias la='ls -lA --color=always'


# Create a couple convenience links if they don't already exist
mkdef() {
  if [ ! -L .profile ]; then
    ln -s esxi.bashrc .profile
  fi

  if [ ! -L datastore ]; then
    store=$(ls -d /vmfs/volumes/data*)
    ln -s $store datastore
  fi
}
