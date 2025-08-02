#! /bin/bash

if ! command -v git -v &>/dev/null; then
	echo -e "\n"
	echo "git could not be found. Install git to proceed."
	exit
fi

if ! command -v zsh -v &>/dev/null; then
	echo -e "\n"
	echo "zsh could not be found. Install zsh to proceed."
	exit
fi

if ! command -v usermod -v &>/dev/null; then
	echo -e "\n"
	echo "usermod could not be found. Install usermod to proceed."
	exit
fi

if ! command -v fzf &>/dev/null; then
	echo -e "\n"
	echo "fzf could not be found. Install fzf to proceed."
	echo "Clone fzf using"
	git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
	echo -e "\n"
	echo "Install fzf using"
	~/.fzf/install
	echo -e "\nRestart Terminal, In case of SSH, disconnect and connect again."
	source ~/.zshrc
	exit 1
fi

if [ -d ~/scripts ]; then
	cd ~/scripts/
	git pull
else
	git clone --depth=1 https://github.com/dkdevgan/scripts.git \
		~/scripts
fi

CONFIG=$HOME/scripts/configs

cd $CONFIG
git pull

cp $CONFIG/.vimrc ~/
cp $CONFIG/.zshrc ~/
cp $CONFIG/.zsh_aliases ~/
cp $CONFIG/.zsh_func ~/
cp $CONFIG/.p10k.zsh ~/
cp $CONFIG/.gdbinit ~/

if [ ! -d ~/.oh-my-zsh ]; then

	# Clone all plugins and themes for zsh
	git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh

	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
		${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

	git clone https://github.com/Aloxaf/fzf-tab \
		${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab

	git clone https://github.com/marlonrichert/zsh-autocomplete.git \
		${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autocomplete

	git clone https://github.com/zsh-users/zsh-autosuggestions \
		${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
		${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

fi

case "$-" in
*i*)
	interactive=1
	sudo cp -rf $CONFIG/fonts/* /usr/share/fonts
	;;
*)
	not_interactive=1
	;;
esac

#chsh -s `which zsh`
if [ $EUID -eq 0 ]
then
	usermod --shell /bin/zsh $USER
else
	sudo usermod --shell /bin/zsh $USER
fi
