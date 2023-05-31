MAKEFLAGS    += -s --always-make -C
SHELL        := bash
.SHELLFLAGS  := -Eeuo pipefail -c

# Get the path to this Makefile and directory
MAKEFILE_DIR := $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))

export NIXPKGS_ALLOW_UNFREE = 1

NIX_FLAGS := --extra-experimental-features nix-command --extra-experimental-features flakes
NIX       := nix $(NIX_FLAGS)

# System bootstrap -------------------------------------
SSH_OPTIONS=-o PubkeyAuthentication=no -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no

bootstrap/copy:
	echo "REMEMBER: have you 'sudo systemctl start sshd' and 'passwd' on the target machine?"
	rsync -av -e 'ssh $(SSH_OPTIONS) -p 22' \
		--exclude='.git/' \
		--exclude='.git-crypt/' \
		$(MAKEFILE_DIR)/ ${or $(user), nixos}@${addr}:~/nix-config

bootstrap/system:
	$(NIX) run github:numtide/nixos-anywhere -- \
		nixos@${addr} \
		--flake ".#${host}" \
		--debug \
		--disk-encryption-keys /tmp/cryptroot.key ./machines/${host}/secrets/cryptroot.key

# Local run --------------------------------------------

system:
	sudo nixos-rebuild switch --flake .#$(host) --show-trace $(flags)

momonoke:
	$(MAKE) system host=momonoke

teriyaki:
	$(MAKE) system host=teriyaki flags=--impure
