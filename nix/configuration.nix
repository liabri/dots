# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  


  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [
    "nvidia-drm.modeset=1"
  ];
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.beta;
  services.xserver.videoDrivers = ["nvidia"];

  # networking
  networking.hostName = "liabri"; 
  networking.wireless.enable = true;
  networking.wireless.userControlled.enable = true;
  networking.wireless.networks.studio.pskRaw = "44b8ad889893ab7bbcd754426f8cd8a9370494ea02db4f53b641d0b0a26981ed"; 
  networking.useDHCP = false;
  networking.interfaces.enp2s0.useDHCP = true;
  networking.interfaces.wlp3s0.useDHCP = true;

  time.timeZone = "Europe/Rome";

  # sound
  services.pipewire =  {
  	enable = true;
	alsa.enable = true;
	alsa.support32Bit = true;
	pulse.enable = true;
	jack.enable = true;
  };

  # opengl
  hardware.opengl.enable = true;

  # compositor
  programs.sway = {
 	enable = true;
	wrapperFeatures.gtk = true; 
  };

  # users
  users.users.liabri = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  # nvidia
  # services.xserver.videoDrivers = ["nvidia"];

  # packages
  programs.steam.enable = true;

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    # opt
    firefox-wayland
    pcmanfm
    sublime4
    discord
    river
    wayfire

    # system utils
    curl
    wget
    htop
    gnome.gnome-system-monitor
    xorg.xeyes
    neofetch
    foot
    # toybox
    git

    # media
    mpv 
    mpd 
    zathura

    # screen manipulation
    slurp
    grim
    wf-recorder
  ];

  # environment variables
  environment.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    XDG_CURRENT_DESKTOP = "sway";
  };

  # fhs integration
  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
      gtkUsePortal = true;
    };
  };

  # services
  services.openssh.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?
}

