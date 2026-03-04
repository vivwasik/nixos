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
        
        function rebuild
            doas nixos-rebuild $argv --flake ~/nixos#laptop
        end

        alias update-flake="pushd ~/nixos; nix flake update; popd"

        alias clear="clear && pfetch"

        pfetch
        starship init fish | source
      '';
    };

    firefox.enable = true;
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
    spotify
    thunderbird
    discord
    bitwarden-desktop
    picard
    nicotine-plus
    amberol
    refine
    celluloid
    vscodium
    apostrophe
    gnome-solanum
    gnome-extension-manager
    prismlauncher
    lunar-client
    tor-browser
    onlyoffice-desktopeditors
    libreoffice
    zoom-us
    deja-dup
    transmission_4-gtk
    
    papirus-icon-theme
    pfetch
    opus-tools
    ffmpeg
    rsgain
    steam-run
    bunnyfetch
    bibata-cursors
    yt-dlp
  ];

  dconf = {
    enable = true;
    settings."org/gnome/mutter" = {
      experimental-features = [ "scale-monitor-framebuffer" ];
    };
    settings."org/gnome/desktop/interface" = {
      font-name = "FiraCode Nerd Font 11";
      document-font-name = "FiraCode Nerd Font 12";
      monospace-font-name = "FiraCode Nerd Font Mono 11";
    };
  };

  home.enableNixpkgsReleaseCheck = false;
  home.stateVersion = "25.05";
}
