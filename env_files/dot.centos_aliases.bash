# Yum aliases
alias ys='yum search'
alias yl='yum list'
alias yi='yum info'
alias yli='yum list installed'        # list installed packages
alias ygl='yum grouplist'
alias ygi='yum groupinfo'
alias yp='yum provides'
alias ydl='yum deplist'           # lists all dependentcies and providing package
alias yrd='yum resolvedep'        # lists packages providing the specified dependecies
alias yrl='yum repolist'          # lists all configured repositories
alias syud='sudo yum update'      # updates specified package or all packages if none specified
alias syup='sudo yum upgrade'     # same as 'update' with the '--obseletes' flag set
alias symc='sudo yum makecache'
alias sygi='sudo yum groupinstall'
alias sygu='sudo yum groupupdate' # groupupdate is just an alias for 'groupinstall'
alias sygr='sudo yum groupremove'
alias syi='sudo yum install'
alias syr='sudo yum remove'
#alias syi='sudo yum -C install'  # -C: use the cache only
#alias syr='sudo yum -C remove'   # -C: use the cache only
#alias sygi='sudo yum -C groupinstall'
#alias sygu='sudo yum -C groupupdate' # groupupdate is just an alias for 'groupinstall'
#alias sygr='sudo yum -C groupremove'


# dnf alias
alias sdi='sudo dnf install'
alias sdmc='sudo dnf makecache'
alias sdr='sudo dnf remove'
alias sdu='sudo dnf upgrade'
alias ds='dnf search'
alias dl='dnf list'
alias di='dnf info'
alias dli='dnf list installed'
alias sdds='sudo dnf distro-sync'
#alias d='dnf '

# vim: set syntax=bash tabstop=2 expandtab:
