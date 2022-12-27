# 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# 補完候補を一覧表示したとき、Tabや矢印で選択できるようにする
zstyle ':completion:*:default' menu select=1 

# AWS
export AWS_PROFILE=default
export AWS_DEFAULT_REGION="ap-northeast-1"
export AWS_SDK_LOAD_CONFIG=1

# node 設定
export PATH=$HOME/.nodebrew/current/bin:$PATH

export JAVA_HOME=`/usr/libexec/java_home`
PATH=${JAVA_HOME}/bin:${PATH}

# peco
function peco-cd {
  local sw="2"
  while [ "$sw" != "0" ]
   do
    if [ "$sw" = "2" ];then
        local list=$(echo -e "---$PWD\n$( ls -a -F | grep / | sed 1d )\n---Show files, $(echo $(ls -F | grep -v / ))\n---HOME DIRECTORY")
      else
        local list=$(echo -e "---BACK\n$( ls -F | grep -v / )")
    fi
    local slct=$(echo -e "$list" | peco )

    if [ "$slct" = "---$PWD" ];then
      local sw="0"
    elif [ "$slct" = "---Show files, $(echo $(ls -F | grep -v / ))" ];then
      local sw=$(($sw+2))
    elif [ "$slct" = "---HOME DIRECTORY" ];then
      cd "$HOME"
    elif [[ "$slct" =~ / ]];then
      cd "$slct"
    elif [ "$slct" = "" ];then
      :
    else
      local sw=$(($sw-2))
    fi
   done
}

# 過去に実行したコマンドを選択。ctrl-rにバインド
function peco-select-history() {
  BUFFER=$(\history -n -r 1 | peco --query "$LBUFFER")
  CURSOR=$#BUFFER
  zle clear-screen
}
zle -N peco-select-history
bindkey '^r' peco-select-history

### 過去に移動したことのあるディレクトリを選択。ctrl-uにバインド
function peco-get-destination-from-cdr() {
  cdr -l | \
  sed -e 's/^[[:digit:]]*[[:blank:]]*//' | \
  peco --query "$LBUFFER"
}
function peco-cdr() {
  local destination="$(peco-get-destination-from-cdr)"
  if [ -n "$destination" ]; then
    BUFFER="cd $destination"
    zle accept-line
  else
    zle reset-prompt
  fi
}
zle -N peco-cdr
bindkey '^u' peco-cdr

### ghq x pecoで取得済みのリポジトリ一覧を表示。ctrl-]にバインド
function peco-src () {
  local selected_dir=$(ghq list -p | peco --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N peco-src
bindkey '^]' peco-src

# cdr, add-zsh-hook を有効にする
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs

# cdr の設定
zstyle ':completion:*' recent-dirs-insert both
zstyle ':chpwd:*' recent-dirs-max 500
zstyle ':chpwd:*' recent-dirs-default true
zstyle ':chpwd:*' recent-dirs-file "$HOME/.cache/shell/chpwd-recent-dirs"
zstyle ':chpwd:*' recent-dirs-pushd true

# alias
alias la='ls -al'
alias ll='ls -l'
alias repos='ghq list -p | peco'
alias repo='cd $(repos)'
alias github='gh-open $(repos)'
alias sd='peco-cd'

# Zi
if [[ ! -f $HOME/.zi/bin/zi.zsh ]]; then
  print -P "%F{33}▓▒░ %F{160}Installing (%F{33}z-shell/zi%F{160})…%f"
  command mkdir -p "$HOME/.zi" && command chmod g-rwX "$HOME/.zi"
  command git clone -q --depth=1 --branch "main" https://github.com/z-shell/zi "$HOME/.zi/bin" && \
    print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
    print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi
source "$HOME/.zi/bin/zi.zsh"
autoload -Uz _zi
(( ${+_comps} )) && _comps[zi]=_zi
zicompinit # <- https://z.digitalclouds.dev/docs/guides/commands

# powerlevel10k
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
zinit light zsh-users/zsh-syntax-highlighting
zinit ice depth=1
zinit light romkatv/powerlevel10k
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# コマンド補完
zinit ice wait'0'; zinit light zsh-users/zsh-completions
autoload -Uz compinit && compinit

# git
function g () {
  if [[ $# > 0 ]]
  then
    git $@
  else
    git status -s
  fi
}
compdef g=git
alias gl='g log --graph --decorate --pretty=oneline --abbrev-commit'
