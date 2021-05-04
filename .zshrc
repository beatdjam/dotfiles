ZSH_THEME="candy"

plugins=(git)
plugins=(git zsh-syntax-highlighting)
plugins=(git zsh-syntax-highlighting zsh-completions)

# zsh-completionsの設定
autoload -U compinit && compinit -u

source $HOME/.oh-my-zsh/oh-my-zsh.sh

# golang
export GOENV_ROOT="$HOME/.goenv"
export PATH="$GOENV_ROOT/bin:$PATH"
eval "$(goenv init -)"
export PATH="$GOROOT/bin:$PATH"
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"

# Python
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

export PATH="$HOME/.poetry/bin:$PATH"

