USER_NAME=$(id -un)
mkdir /Users/${USER_NAME}/.cache/shell

ln -sv ~/dotfiles/.vimrc ~/
ln -sv ~/dotfiles/.ideavimrc ~/
ln -sv ~/dotfiles/.zshrc ~/

sh -c "$(curl -fsSL https://git.io/get-zi)" --
source ~/.zshrc
zinit self-update
