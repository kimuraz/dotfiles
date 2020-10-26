SHELL := /bin/bash
OS_NAME := $(shell uname -s | tr A-Z a-z)

install:
	# Only supports Linux (deb based with apt) and MacOS
	# Copying dotfiles
	echo "Copying all dot files"
	cp -rf ./.[a-z]* ~/.

	# Reloading bash file
	echo "Reload bash file"
ifeq '$(OS_NAME)' 'linux'

		echo "Updating packages and installing dependencies"

		sudo apt update
		sudo apt install -y wget git vim tmux sl apt-transport-https ca-certificates curl software-properties-common fzf
		curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
		sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(. /etc/os-release; echo "$UBUNTU_CODENAME") stable"
		sudo apt update
		sudo apt install -y docker-ce docker-compose
		sudo usermod -aG docker $(USER)
		curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.36.0/install.sh | bash
		source ~/.bashrc

else

		echo "Installing homebrew and other dependencies"

		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
		brew install wget git vim tmux nvm sl fzf
		wget -O ~/Downloads/Docker.dmg https://desktop.docker.com/mac/stable/Docker.dmg
		echo "Docker was downloaded on ~/Downloads folder, install it!"
		mv .bashrc .bash_profile
		source ~/.bash_profile

endif
	# Install tmux plugin manager
	echo "Installing tmux plugin manager"
	echo "Do not forget to run CTRL + b + I to instal plugins afterwards"

	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

	# Install Vundle
	echo "Installing vundle"
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

	# Install vim plugins
	echo "Installing vim plugins automatically"
	vim +PluginInstall +qall

	# Reload tmux.conf
	echo "Reloading tmux config file"
	tmux source-file ~/.tmux.conf
	
	echo "Bye!"
