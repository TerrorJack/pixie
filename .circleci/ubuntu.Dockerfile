FROM ubuntu:disco

ADD debian-bootstrap.sh nix.conf /tmp/
RUN sh -e /tmp/debian-bootstrap.sh

ENV \
  DEBIAN_FRONTEND=noninteractive \
  FONTCONFIG_FILE=/etc/fonts/fonts.conf \
  LANG=en_US.UTF-8 \
  LC_ALL=en_US.UTF-8 \
  LC_CTYPE=en_US.UTF-8 \
  LOCALE_ARCHIVE=/usr/lib/locale/locale-archive \
  NIX_PATH=nixpkgs=/root/.nix-defexpr/channels/nixpkgs:/root/.nix-defexpr/channels \
  NIX_SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt \
  PATH=/root/.nix-profile/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

WORKDIR /root
CMD ["/bin/bash"]
