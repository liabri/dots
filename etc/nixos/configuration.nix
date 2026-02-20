{ config, pkgs, stable, awww, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.loader = {
    efi = {
      canTouchEfiVariables = false;
      efiSysMountPoint = "/boot";
    };
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      useOSProber = true; # this detects windows on the same ssd
      efiInstallAsRemovable = true; # this ensure the BIOS sees it as a standard bootable drive
    };
  };

  boot.blacklistedKernelModules = [ "i915" "nouveau" ];
  boot.kernelParams = [
    "intel_iommu=on" # fixes the DMAR BIOS error
    "igfx_off" # disables integrated graphics
  
    "nvidia-drm.modeset=1" # ensures NVIDIA plays nice
    "nvidia_drm.fbdev=1"
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1" # ensures NVIDIA plays nice

    # to deal with my NVMe running thru a PCIe adapter on PCIe 2.0 lane on a Z87
    "nvme_core.io_timeout=255" # increase kernel wait time for NVMe response
    "nvme_core.default_ps_max_latency_us=0" # disables deep sleep since Z87 struggles
    "pcie_aspm=off" # disables PICe power management 
    "pci=nommconf" # legacy PCIe bus comms
  ];

  # ALFA AWUS036ACH Wi-Fi adapter
  boot.extraModulePackages = [ config.boot.kernelPackages.rtl8812au ];
  boot.kernelModules = [ "8812au" ];

  networking.hostName = "venus";
  networking.networkmanager.enable = true;
  networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];

  # dm
  services.displayManager.ly.enable = true;

  # compositor (niri)
  services.displayManager.sessionPackages = [ pkgs.niri ];
  systemd.packages = [ pkgs.niri ];
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ]; # or xdg-desktop-portal-kde
  };
  xdg.portal.configPackages = [ pkgs.niri ];

  # sound
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
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

  
  users.users.liabri = {
    isNormalUser = true;
    description = "liam";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # pkgs
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    # basic
    foot		# terminal
    niri		# compositor
    zathura		# docs
    zed-editor 		# editor
    thunar 		# file manager
    fuzzel  		# application launcher 
    mpv 		# video player
    swayimg		# image viewer
    eww 		# widget
    ly 			# display manager
    firefox		# browser 		
    webcord 		# discord
    (awww.packages.${pkgs.stdenv.hostPlatform.system}.awww) # wallpaper daemon
 
    # tools
    unzip		
    xwayland-satellite	# xwayland support
    brightnessctl	# brightness control
    curl
    wl-clip-persist	# clipboard persists
    wl-clipboard 	# wl-copy and wl-paste
    ncdu		# filesystem info
    fastfetch		# system info
    btop		# system monitor
    (pass.withExtensions (exts: [ exts.pass-otp ]))
    git 		# git
    git-lfs 		# git for big files
    gnupg 		# gpg keys
    pinentry-curses	# password prompt

    # env
    javaPackages.compiler.temurin-bin.jre-21

    # specialised software
    steam
    gimp
    (stable.legacyPackages.x86_64-linux.freecad)
    prismlauncher
 ];


  # vulkan
  hardware.graphics = { enable = true; enable32Bit = true; };
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false; # often causes freezes
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  hardware.cpu.intel.updateMicrocode = true;


  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    LIBVA_DRIVER_NAME = "nvidia";
    MOZ_ENABLE_WAYLAND = "1";
  };


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
