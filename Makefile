MAKEFLAGS    += -s --always-make -C
SHELL        := bash
.SHELLFLAGS  := -Eeuo pipefail -c

export NIXPKGS_ALLOW_UNFREE = 1

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
