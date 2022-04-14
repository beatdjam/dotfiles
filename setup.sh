USER_NAME=$(id -un)
mkdir /Users/${USER_NAME}/.cache/shell

ln -fsv ~/ghq/github.com/beatdjam/dotfiles/.vimrc ~/
ln -fsv ~/ghq/github.com/beatdjam/dotfiles/.ideavimrc ~/
ln -fsv ~/ghq/github.com/beatdjam/dotfiles/.zshrc ~/

sh -c "$(curl -fsSL https://git.io/get-zi)" --
source ~/.zshrc
zinit self-update
