#! /bin/bash

CONFIG=~/scripts/configs
BRANCH="$(hostname)-$(date "+%Y-%m-%d-%H-%M-%S")"
if [ -f ~/.dkdevgan-configured ]; then
	cd ~/scripts
	git pull
	cp ~/.vimrc $CONFIG
	cp ~/.zshrc $CONFIG
	cp ~/.zsh_func $CONFIG
	cp ~/.zsh_aliases $CONFIG
	cp ~/.p10k.zsh $CONFIG
	cp ~/.gdbinit $CONFIG

	if [[ $(git status --porcelain) ]]; then
		git checkout -b $BRANCH

		git add configs/.vimrc \
			configs/.zshrc \
			configs/.zsh_func \
			configs/.p10k.zsh \
			configs/.zsh_aliases \
			configs/.gdbinit

		git add dkdevgan-*

		git status

		git commit -s -m "Updated at $(date "+%Y-%m-%d %H:%M:%S")"
		echo -e "\n\nPushing All configs to scripts repo\n\n"
		git push --set-upstream origin $BRANCH
	fi
	git checkout main
else
	read -p "Do you want this user to be configured as dkdevgan-configured? [N/y]" yn
	case $yn in
	[yY])
		touch ~/.dkdevgan-configured
		;;
	*) echo Skipping Configuration ;;
	esac

fi

cd
