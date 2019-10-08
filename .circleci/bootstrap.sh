#!/bin/sh -e

apk add --no-cache --no-progress \
  bzip2 \
  coreutils \
  sed \
  shadow \
  sudo \
  tar \
  wget \
  xz

groupadd -g 30000 --system nixbld

for i in $(seq 1 32); do
  useradd \
    --home-dir /var/empty \
    --gid 30000 \
    --groups nixbld \
    --no-user-group \
    --system \
    --shell /root/.nix-profile/sbin/nologin \
    --uid $((30000 + i)) \
    --password "!" \
    nixbld$i
done

mkdir -p \
  /root/.config/nix \
  /root/.nixpkgs
mv /tmp/nix.conf /root/.config/nix/nix.conf
echo "{ allowUnfree = true; }" > /root/.nixpkgs/config.nix

cd /tmp
wget -O - https://nixos.org/releases/nix/nix-2.3/nix-2.3-x86_64-linux.tar.xz | tar xJf -
cd nix-2.3-x86_64-linux
USER=root ./install --no-daemon

export NIX_PATH=nixpkgs=/root/.nix-defexpr/channels/nixpkgs:/root/.nix-defexpr/channels
export NIX_SSL_CERT_FILE=/root/.nix-profile/etc/ssl/certs/ca-bundle.crt
export PATH=/root/.nix-profile/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

nix-channel --update
nix-env -iA \
  nixpkgs.bashInteractive \
  nixpkgs.cacert \
  nixpkgs.coreutils \
  nixpkgs.glibcLocales \
  nixpkgs.iana-etc \
  nixpkgs.nix

sed -e "s|/bin/ash|/bin/bash|g" -i /etc/passwd

nix-channel --remove nixpkgs
rm -rf /nix/store/*-nixpkgs*
nix-collect-garbage -d
nix-store --verify --check-contents
nix optimise-store
rm -rf /tmp/*
