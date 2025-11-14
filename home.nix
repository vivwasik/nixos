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
        fish_add_path ~/.local/bin

	      alias rebuild="doas nixos-rebuild switch --flake ~/nixos#laptop"
        alias update-flake="pushd ~/nixos; nix flake update; popd"
        alias clear="clear && pfetch"
        pfetch

        starship init fish | source
      '';
    };
  };

  services = {
    rescrobbled = {
      enable = true;
      settings = {
        lastfm-key = "def5429211e7e3f0207bbc2f8d5c27eb";
        lastfm-secret = "e523ff55fcd902f1aa03f67f9048b7ba";
        player-whitelist = [
          "io.bassi.Amberol"
        ];
      };
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
    gnome-solanum
    gnome-extension-manager
    
    papirus-icon-theme
    pfetch
    opusTools
    ffmpeg
    rsgain
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
