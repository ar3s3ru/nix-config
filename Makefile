MAKEFLAGS    += -s --always-make -C
SHELL        := bash
.SHELLFLAGS  := -Eeuo pipefail -c

# Get the path to this Makefile and directory
MAKEFILE_DIR := $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))

export NIXPKGS_ALLOW_UNFREE = 1

# System bootstrap -------------------------------------
SSH_OPTIONS=-o PubkeyAuthentication=no -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no

bootstrap/copy:
	echo "REMEMBER: have you 'sudo systemctl start sshd' and 'passwd' on the target machine?"
	rsync -av -e 'ssh $(SSH_OPTIONS) -p 22' \
		--exclude='.git/' \
		--exclude='.git-crypt/' \
		--rsync-path="sudo rsync" \
		$(MAKEFILE_DIR)/ nixos@${addr}:~/nix-config

bootstrap/system:
	nix run github:numtide/nixos-anywhere -- \
		nixos@${addr} \
		--flake ".#${host}" \
		--debug \
		--disk-encryption-keys /tmp/cryptroot.key ./machines/${host}/secrets/cryptroot.key

# Local run --------------------------------------------

system:
	sudo nixos-rebuild switch --flake .#$(host)

momonoke:
	$(MAKE) system host=momonoke

# MacOS configuration stuff ----------------------------

P5XVK45RQP:
	nix --extra-experimental-features nix-command \
		--extra-experimental-features flakes \
		build .#darwinConfigurations.P5XVK45RQP.system
	echo "switching to new version..."
	./result/sw/bin/darwin-rebuild switch --flake .
	echo "all done!"
