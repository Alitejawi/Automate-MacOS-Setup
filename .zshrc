# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export PYTHONPATH=${PYTHONPATH}:/Users/aalitejawi/Documents/Work/python_modules

# Path to your oh-my-zsh installation.
export ZSH="/Users/aalitejawi/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="dracula-pro"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)
ZSH_DISABLE_COMPFIX=true

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias dep_search="/Users/aalitejawi/Documents/Work/jamf_find_dep_computer/jamf_find_dep_computer_final.py"

###################
# JSS (SELECTED NODES) Centos 7+
#####

SERVERS=( )
export SERVERS

batch() {
    
    # Verbs
    case $1 in
        ( cmd )
            # Run a command on the servers
            for SERVER in ${SERVERS[@]}; do
                if host $SERVER &>/dev/null; then
                    printf "\n${KGRN}$SERVER: ${KNRM}\n"
                    ssh $USER@$SERVER "${@:2}"
                    hr
                fi
            done
            return
            ;;
        ( get )
            # Get files and directories from the servers
            DOWNFOLDER="/Users/aalitejawi/Downloads/$(date +"%Y.%m.%d-%H.%M.%S")"
            mkdir $DOWNFOLDER

            for SERVER in ${SERVERS[@]}; do
                if host $SERVER &>/dev/null; then
                    printf "\n${KRED}$SERVER: ${KNRM}\n"
                    mkdir "$DOWNFOLDER/$SERVER"
                    for FILE in ${@:2}; do
                        /usr/bin/scp -r "$SERVER:$FILE" "$DOWNFOLDER/$SERVER"
                    done
                    hr
                fi
            done
            return
            ;;
        ( send )
            # Send files and directories to the servers /tmp directory
            for SERVER in ${SERVERS[@]}; do
                if host $SERVER &>/dev/null; then
                    printf "\n${KYEL}$SERVER: ${KNRM}\n"
                    for FILE in ${@:2}; do
                        /usr/bin/scp -r "$FILE" "$SERVER:/tmp"
                    done
                    hr
                fi
            done
            return
            ;;
        ( addservers | addserver )
            # Add specific servers
            for SERVER in ${@:2}; do
                printf "Addding $SERVER ... "
                if [[ ! " ${SERVERS[@]} " =~ " $SERVER " ]]; then
                    SERVERS+=( $SERVER )
                    printf "${KGRN}Added${KNRM}\n"
                else
                    printf "${KRED}Already exists${KNRM}\n"
                fi
            done
            ;;
        ( removeservers | removeserver )
            # Remove specific servers
            for SERVER in ${@:2}; do
                printf "Removing $SERVER ... "
                if [[ " ${SERVERS[@]} " =~ " $SERVER " ]]; then
                    SERVERS=( "${SERVERS[@]/$SERVER}" )
                    printf "${KGRN}Removed${KNRM}\n"
                else
                    printf "${KRED}Nothing to remove${KNRM}\n"
                fi
            done
            ;;
        ( clearservers )
            # Clear all servers from the list
            SERVERS=( )
            printf "${KGRN}Removed all servers\n"
            printf "${KNRM}"
            ;;
        ( setservers )
            SERVERS=( ${@:2} )
            printf "${KGRN}Servers set to: ${KNRM}\n"
            ;;
        ( customset )
            case $2 in
                ( ams )
                SERVERS=( )
                for SERVER in ams4-jss{dmz,cor,api}-0{3..4}.corpad.adbkng.com; do
                    if host $SERVER &>/dev/null; then
                        SERVERS+=( $SERVER )  
                    fi
                done
                ;;
                ( lhr )
                SERVERS=( )
                for SERVER in lhr4-jss{dmz,cor,api}-0{3..4}.corpad.adbkng.com; do
                    if host $SERVER &>/dev/null; then
                        SERVERS+=( $SERVER )  
                    fi
                done
                ;;
            esac
            ;;
        ( defaults | default | init | reset )
            # Reset to a default
            SERVERS=( )
            [ ${#@} -lt 2 ] && printf "${KGRN}Servers reset to: \n"
            for SERVER in {ams,lhr}4-jss{dmz,cor,api}-0{3..4}.corpad.adbkng.com; do
                if host $SERVER &>/dev/null; then
                    SERVERS+=( $SERVER )  
                fi
            done
            printf "${KNRM}"
            [ ${#@} -ge 2 ] && return
            ;;
        ( * )
            # Handle list and print and anything else really
            printf "${KGRN}Current set:\n${KNRM}"
            ;;
    esac
    
    printf "%s\n" ${SERVERS[@]}
}

_batch () {
    local state
    #_arguments '1: :(cmd get send addservers removeservers clearservers setservers customset defaults reset list print )' '2: :->option'
    _arguments '1: :->verb' '2: :->option'


    case $state in
        ( verb )
            _describe 'command' "( \
            'cmd:Run a command on the batch of servers' \
            'get:Get files and directories from the batch of servers' \
            'send:Send files and directories to the /tmp on the batch of servers' \
            'addservers:Add (a) server(s) to the batch of servers' \
            'removeservers:Remove (a) server(s) to from batch of servers' \
            'clearservers:Clear all servers to from batch of servers' \
            'setservers:Set (a) server(s) to be batch of servers' \
            'customset:Set the servers to a custom batch' \
            'defaults:Set the servers to a default batch' \
            'list:List the batch of servers' \
            )"
            ;;
        ( option )
            if [ "$words[2]" = "customset" ]; then
                _describe 'command' "( \
                'ams:Custom set ams servers' \
                'lhr:Custom set lhr servers' \    
                )"
            fi
            ;;
    esac


}
compdef _batch batch

batch init 0

hr() {
    printf "%$(tput cols)s\n" | tr " " "="
}

function apropos() {
    local SEARCH="${1:-.}"
    local SECTIONS="${2:-124678}"

    # Turn off line wrapping:
    printf '\033[?7l'
    /usr/bin/man -k $SEARCH 2> /dev/null | grep -E "\([${SECTIONS}]\)" | grep -v builtin
    # Turn on  line wrapping:
    printf '\033[?7h'
}

###################
# SSH
#####

# Before running ssh:
#    1. Check that ssh key is present and retrieve
#    2. ssh
ssh () {
    if ( ping -c 1 -q ssh.booking.com &>/dev/null ); then
        if [ "$(ssh-add -L)" = "The agent has no identities." ]; then
            echo "Temporary key is: Expired.  Renewing..."
            /usr/bin/ssh ssh.booking.com
        fi
    fi
    
    if [ ! -z "$1" ]; then
        /usr/bin/ssh ${@}
    else
        echo "Logged in"
    fi
}
: <<'BLOCK'
###################

source ~/.oh-my-zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/powerlevel10k/powerlevel10k.zsh-theme
source ~/powerlevel10k/powerlevel10k.zsh-theme



# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
