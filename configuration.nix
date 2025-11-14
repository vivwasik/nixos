# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = false;
    };
    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };
    kernelPackages = pkgs.linuxPackages_zen;
    plymouth.enable = true;
  };
  
  networking.hostId = "e5a29261";
  
  nixpkgs.config.allowUnfree = true;

  environment.persistence."/persist" = {
    hideMounts = true;
    files = [
      "/etc/machine-id"
      "/root/.gitconfig"
    ];
    directories = [
      "/var/log"
      "/var/lib/nixos"
      "/var/lib/sbctl"
      "/var/lib/bluetooth"
      "/var/lib/fprint"
      "/etc/NetworkManager/system-connections"
      "/etc/mullvad-vpn"
    ];
  };

  zramSwap.enable = true;

  networking.hostName = "laptop";
  networking.networkmanager.enable = true;

  time.timeZone = "America/New_York";

  services.fprintd.enable = true;
  security.pam.services.login.fprintAuth = false;
  security.pam.services.gdm-fingerprint.fprintAuth = true;

  age.secrets.password.file = ./secrets/password.age;
  users.mutableUsers = false;
  users.users.viv = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "wheel" "networkmanager" ];
    hashedPasswordFile = config.age.secrets.password.path;
  };
  programs.fish.enable = true;

  security.doas.enable = true;
  security.sudo.enable = false;
  security.doas.extraRules = [{
    groups = ["wheel"];
    keepEnv = true;  # Optional, retains environment variables while running commands
    persist = true;  # Optional, only require password verification a single time
  }];

  environment.systemPackages = with pkgs; [
    git
    sbctl
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    gamescopeSession.enable = true;
  };

  services = {
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;

    mullvad-vpn = {
      enable = true;
      package = pkgs.mullvad-vpn;
    };

    printing.enable = true;
  };
  
  environment.gnome.excludePackages = with pkgs; [
    totem
    epiphany
    geary
    decibels
    seahorse
    showtime
    gnome-calendar
    gnome-connections
    gnome-contacts
    gnome-logs
    gnome-maps
    gnome-music
    gnome-tour
    gnome-weather
  ];
  
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
  ];

  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  
  age.secrets.github-oath.file = ./secrets/github-oath.age;

  nix = {
    settings = {
      experimental-features = [
        "flakes"
        "nix-command"
      ];
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    extraOptions = ''
      !include ${config.age.secrets.github-oath.path}
    '';
  };

  services.openssh.enable = true;
  
  system.stateVersion = "25.11"; # Did you read the comment?

}

