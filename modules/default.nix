{ config, lib, pkgs, ... }:

{
  imports = [
    ./reverse-proxy
    ./virtualisation
    ./social
    ./file-server
    ./samba
    ./searxng
    ./auth
    ./development
    ./window-manager
  ];
}
