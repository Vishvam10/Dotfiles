# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# This is for perf analysis. Uncomment if something is slow and
# check what is casuing the problem.
# zmodload zsh/zprof

# =========================================================
# Basic Setup
# =========================================================
typeset -U PATH
autoload colors; colors;

ZSH_THEME="powerlevel10k/powerlevel10k"
export ZSH="$HOME/.oh-my-zsh"

# =========================================================
# Auto Completion and Correction
# =========================================================

# Speed up completion init, see:
# https://gist.github.com/ctechols/ca1035271ad134841284
autoload -Uz compinit
for dump in ~/.zcompdump(N.mh+24); do
  compinit
done
compinit -C

# Interesting though, pause and resume terminal stuff. Should look into it but
# for the time being, I'm disabling it
unsetopt flowcontrol

# Wish I read the manual earlier
setopt auto_menu
setopt complete_in_word
setopt always_to_end
setopt auto_pushd

# /Wish I read the manual earlier

# CASE_SENSITIVE="true"

# Case-sensitive completion must be off.  _ and - will
# be interchangeable.
# HYPHEN_INSENSITIVE="true"

# ENABLE_CORRECTION="true"

# =========================================================
# Keybindings
# =========================================================

bindkey '^[[3;5~' kill-whole-line       # Shift + Delete
bindkey '^[[3;2~' backward-kill-word    # Command + Delete

# =========================================================
# Plugins
# =========================================================

plugins=(
  git
  docker
  zsh-autosuggestions
  zsh-completions
  zsh-history-substring-search
  zsh-syntax-highlighting
)


source $ZSH/oh-my-zsh.sh

# =========================================================
# Editor
# =========================================================

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='zed'
else
  export EDITOR='zed'
fi

# =========================================================
# Aliases
# =========================================================

alias c="clear"

# DO NOT USE --total-size. It takes a shit ton of time. Do
# strace -c with that flag to see the difference
alias ls="eza  -Thl --git-ignore --git-repos-no-status --level=1 -s name --group-directories-first --no-permissions --no-user --hyperlink"

alias nfiles="find -type f | wc -l"

alias ol="ollama run llama3"
alias olr="sudo systemctl restart ollama"

alias gpu="watch -n 1 nvidia-smi"

alias de="cd ~/Desktop"
alias dev="cd ~/Desktop/Dev"
alias do="cd ~/Downloads"

alias nj="npx jest --"
alias vt="npx vitest"
alias vtc="npx vitest --coverage"

alias dlb="delete-local-branches"es

alias pt="npm run playwright"
alias pr="npx playwright show-report"
alias pc="npm run playwright:codegen"

alias python="python3"
alias pip="pip3"
alias vv="python3 -m venv venv"
alias va="source venv/bin/activate"
alias ca="conda activate venv"

alias spp='export PYTHONPATH=$(pwd)'

alias sshconf="zed ~/.ssh/config"
alias zconf="zed ~/.zshrc"

delete-local-branches() {
  # Fetch latest updates from remote
  git fetch --all --prune

  # List local branches that have been merged into the remote-tracking branch, except 'develop', 'master', and 'main', 'stage'
  branches=$(git branch --merged origin/main | grep -Ev 'develop|development|dev|master|staging|stage|main|prod' | sed 's/^[ *]*//')

  echo "$branches"

  if [ -z "$branches" ]; then
    echo "No branches to delete."
    return
  fi

  echo "The following branches will be deleted:"
  echo "$branches"

  echo -n "Are you sure you want to delete these branches? (y/n) "
  read confirm
  if [ "$confirm" = "y" ]; then
    echo "$branches" | xargs -n 1 git branch -D
    echo "Branches deleted."
  else
    echo "Operation cancelled."
  fi
}

# Lazy load nvm to improve startup time
lazy_load_nvm() {
  unset -f node npm npx nvm
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
}

tree() {
    find $1 -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'
}

node() { lazy_load_nvm; command node "$@"; }
npm() { lazy_load_nvm; command npm "$@"; }
npx() { lazy_load_nvm; command npx "$@"; }

# For some reason, you need to do "node / npm / npx / nvm" only then you can
# use nvm. Don't know why. Don't care.
nvm() { load_nvm; command nvm "$@"; }


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('$HOME/miniforge3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$HOME/miniforge3/etc/profile.d/conda.sh" ]; then
        . "$HOME/miniforge3/etc/profile.d/conda.sh"
    else
        export PATH="$HOME/miniforge3/bin:$PATH"
    fi
fi
unset __conda_setup

if [ -f "$HOME/miniforge3/etc/profile.d/mamba.sh" ]; then
    . "$HOME/miniforge3/etc/profile.d/mamba.sh"
fi
# <<< conda initialize <<<

export PATH="$PATH:$HOME/Desktop/Dev/Flutter-SDK/flutter/bin"

# This is for perf analysis. Uncomment if something is slow and
# check what is casuing the problem.
# zprof

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
