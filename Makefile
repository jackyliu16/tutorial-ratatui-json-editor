###################
# Nix Instruction #
###################
.PHONY: install-nix uninstall-nix monitor

SHELL := bash

# Install Single-User Nix into your system
install-nix:
	if ! command -v nix >/dev/null 2>&1; then \
		echo "Installing Nix...";\
		curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install;\
	else \
		echo "You have already installed Nix.";\
	fi
	# ref:
	# https://nixos.org/download.html
	# https://www.reddit.com/r/NixOS/comments/wyw7pa/multi_user_vs_single_user_installation/
	# sh <(curl -L https://nixos.org/nix/install) --no-daemon;\

# Uninstall Single-User Nix 
uninstall-nix:
	@echo "will removing nix single user installing in 5 seconds... <using Ctrl + C to stop it>";
	@sleep 1 && echo "will removing nix single user installing in 4 seconds... <using Ctrl + C to stop it>";
	@sleep 1 && echo "will removing nix single user installing in 3 seconds... <using Ctrl + C to stop it>";
	@sleep 1 && echo "will removing nix single user installing in 2 seconds... <using Ctrl + C to stop it>";
	@sleep 1 && echo "will removing nix single user installing in 1 seconds... <using Ctrl + C to stop it>";
	/nix/nix-installer uninstall
	# ref:
	# https://nixos.org/download.html#nix-install-linux
	# https://github.com/NixOS/nix/pull/8334

monitor:
	 inotifywait --event=create --event=modify --event=moved_to --exclude='/(dev|nix|proc|run|sys|tmp|var)/.*' --monitor --no-dereference --quiet --recursive /
	# ref:
	# https://github.com/NixOS/nix/pull/8334

#######################
# general instruction #
#######################

# Running development environment
env:
	nix develop .# --impure --extra-experimental-features nix-command --extra-experimental-features flakes --option substituters "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
	
# rebuild all environment
clean: 
	rm -rf .venv .devenv
clean-dev:
	rm -rf .devenv
git-log:
	git log --graph --abbrev-commit --decorate --date=relative --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'


.PHONY: clean-env env git-log

######################
# Coding instruction #
######################
.PHONY: layout

layout:
ifeq ($(IN_NIX_SHELL),impure)
	zellij -l .zellij.kdl
else
	echo "you should run make env first to make you inside the nix shell environment";
endif
