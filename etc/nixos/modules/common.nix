{ config, pkgs, stable, awww, ... }:

{
 
  # ---------------
  # --- desktop ---
  # ---------------

  # dm
  services.displayManager.ly.enable = true;

  # compositor (niri)
  services.displayManager.sessionPackages = [ pkgs.niri ];
  systemd.packages = [ pkgs.niri ];

  # portals
  programs.dconf.enable = true; # required for gnome portal
  xdg.portal = {
    enable = true;
    extraPortals = [ 
      pkgs.xdg-desktop-portal-gtk 
      pkgs.xdg-desktop-portal-gnome
    ];
    configPackages = [ pkgs.niri ]; 
  };

  # --------------
  # --- system ---
  # --------------

  # sound
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  # bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        # Shows battery charge of connected devices on supported
        # Bluetooth adapters. Defaults to 'false'.
        Experimental = true;
        # When enabled other devices can connect faster to us, however
        # the tradeoff is increased power consumption. Defaults to
        # 'false'.
        FastConnectable = true;
      };
      Policy = {
        # Enable all controllers when they are found. This includes
        # adapters present on start as well as adapters that are plugged
        # in later on. Defaults to 'true'.
        AutoEnable = true;
      };
    };
  };

  # ------------------
  # --- networking ---
  # ------------------
 
  networking.networkmanager.enable = true;
  networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];

  # -------------
  # --- users ---
  # -------------

  users.users.liabri = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # ----------------
  # --- packages ---
  # ----------------

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    # basic
    foot		# terminal
    niri		# compositor
    swayimg		# image viewer
    ly 			# display manager
    firefox		# browser
    (awww.packages.${pkgs.stdenv.hostPlatform.system}.awww) # wallpaper daemon
    pavucontrol
    bluetui

    # tools
    curl
    unzip
    ncdu
    wl-clip-persist	# clipboard persists
    wl-clipboard 	# wl-copy and wl-paste
    fastfetch		# system info
    btop		# system monitor
    brightnessctl 	# brightness control
 ];

  # -------------------
  # --- environment ---
  # -------------------
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    MOZ_ENABLE_WAYLAND = "1";
  };

  # ssh
  services.openssh.enable = true;

  # shell
  users.defaultUserShell = pkgs.yash;

  # locale
  time.timeZone = "Europe/Rome";
  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.extraLocales = [ "en_US.UTF-8/UTF-8" "fr_FR.UTF-8/UTF-8" "mt_MT.UTF-8/UTF-8" ];
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  # -----------------
  # --- nix stuff ---
  # -----------------

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true; # deduplication of nix-store

  # maintenance service of nix store: garbage collections while retaining last 3 generations
  systemd.services.nix-clean-up = {
    description = "Keep 3 gens and GC";
    serviceConfig.Type = "oneshot";
    script = ''
      ${pkgs.nix}/bin/nix-env --profile /nix/var/nix/profiles/system --delete-generations +3 # clean system profile
      ${pkgs.nix}/bin/nix-env --profile /nix/var/nix/profiles/per-user/liabri/profile --delete-generations +3 #clean liabri profile
      ${pkgs.nix}/bin/nix-collect-garbage # throw out the rubbish
    '';
  };

  # run maintenance service every monday morning
  systemd.timers.nix-clean-up = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "weekly";
      Persistent = true; # runs immediately if computer was off during scheduled time
    };
  };

  # clean up of my session installations
  systemd.tmpfiles.rules = [
    # R = Remove path on boot
    # Type  Path                                         Mode  User    Group   Age  Argument
    "R      /home/liabri/.local/state/nix/profiles/session -     -       -       -    -"
    "R      /home/liabri/.cache/nix-session                -     -       -       -    -"
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
}
