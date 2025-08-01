{ inputs, config, lib, pkgs, username, extraHomeModules, ... }:

{
  imports = [
    ../../minimal.nix
    ../hardware-configuration.nix
    ../disko-config.nix

    ./sops.nix
  ];

  users.users.${username} = {
    description = "NixOS Omen Laptop";
    hashedPassword =
      "$6$5xuxfP8HapkkyDa5$qr2wkpibMaNSIiJIPojWC4CO1X31HNJZEfmYfReYrwOSoflf0rMrQk.EZj5uzh/K/NalQMnCiDcmvFBuf9a5p0";
    packages = with pkgs; [
      # thunar plugin to manager archives
      xfce.thunar-archive-plugin
    ];
  };

  programs = {
    nix-ld.dev.enable = true;

    light.enable = true;

    nm-applet.enable = true;

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  ###
  # Thunar configurations
  ###
  programs.thunar.enable = true;
  programs.xfconf.enable = true; # needed to save preferences
  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images
  ###
  ###

  dov = {
    development.emacs.enable = true;

    virtualisation.docker.enable = true;
  };

  ###
  # Home Manger configuration
  ###
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    extraSpecialArgs = { inherit inputs username; };

    users."${username}" = { imports = [ ./home.nix ] ++ extraHomeModules; };
  };

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";

    fonts = {
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };

      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };

      monospace = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans Mono";
      };

      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };
  };

  fonts.packages = with pkgs;
    [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      liberation_ttf
      fira-code
      fira
      fira-code-symbols
      mplus-outline-fonts.githubRelease
      dina-font
      proggyfonts
      emacs-all-the-icons-fonts
      emacsPackages.all-the-icons
      font-awesome_5
      source-code-pro
    ] ++ builtins.filter lib.attrsets.isDerivation
    (builtins.attrValues pkgs.nerd-fonts);

  # DO NOT CHANGE AT ANY POINT!
  system.stateVersion = "25.11";
}
