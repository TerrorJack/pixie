# `pixie`

[![CircleCI](https://circleci.com/gh/TerrorJack/pixie/tree/master.svg?style=shield)](https://circleci.com/gh/TerrorJack/pixie/tree/master)
![Docker Pulls](https://img.shields.io/docker/pulls/terrorjack/pixie.svg)

Yet another Docker image for Nix.

## Notes

* `terrorjack/pixie:latest` only contains Nix; `terrorjack/pixie:debian` is based on Debian sid, `terrorjack/pixie:ubuntu` on Ubuntu disco.
* `nixpkgs` and `apt` repositories are stripped from the images. Run `nix-channel --add https://nixos.org/channels/nixpkgs-unstable && nix-channel --update` to retrieve the latest release of `nixpkgs`, `apt update` to update `apt` repositories.
* For basic usage on CircleCI, install `nixpkgs.{gitMinimal,openssh}` before `checkout`. Additionally, CircleCI caching require `nixpkgs.{gnutar,gzip}`.
* `LANG` is set to `en_US.UTF-8` in all images.
* For `fontconfig` to find the default config file, set `FONTCONFIG_FILE=$(nix eval --raw nixpkgs.fontconfig.out.outPath)/etc/fonts/fonts.conf`. In the Nix/Debian hybrid image, it's already set to `/etc/fonts/fonts.conf`, but you still need to `apt install fontconfig` manually first.
* For `nix-env -q` to work, install `less`.
* For manpages to work, install `{gzip,less,man}`.
* Automatic detection of CPU core number on CircleCI is unreliable, please manually set core number based on the resource class (`--cores 2` for the default `medium` class).
