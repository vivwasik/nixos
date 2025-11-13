{ config, pkgs, inputs, ... }:

{
  home.username = "viv";
  home.homeDirectory = "/home/viv";

  programs = {
    git = {
      enable = true;
      settings = {
        user = {
          name = "vivwasik";
          email = "wasik@mailbox.org";
          signingkey = "~/.ssh/id_ed25519.pub";
        };
        commit.gpgsign = true;
        gpg.format = "ssh";
      };
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    starship.enable = true;
    fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting # Disable greeting

	alias rebuild="doas nixos-rebuild switch --flake ~/nixos#laptop"
        alias clear="clear && pfetch"
        pfetch

        starship init fish | source
      '';
    };
  };

  home.packages = with pkgs; [
    firefox
    spotify
    thunderbird
    discord
    bitwarden-desktop
    picard
    nicotine-plus
    amberol
    pika-backup
    fragments
    refine
    celluloid
    vscodium
    
    papirus-icon-theme
    pfetch
    opusTools
    ffmpeg
    
    gnomeExtensions.alphabetical-app-grid
    gnomeExtensions.caffeine
  ];

  dconf = {
    enable = true;
    settings."org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = with pkgs.gnomeExtensions; [
        alphabetical-app-grid.extensionUuid
        caffeine.extensionUuid
      ];
    };
    settings."org/gnome/mutter" = {
      experimental-features = [ "scale-monitor-framebuffer" ];
    };
  };

  home.stateVersion = "25.05";
}
