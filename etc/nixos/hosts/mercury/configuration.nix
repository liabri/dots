{ config, pkgs, stable, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../modules/common.nix
    ];

  # --------------
  # --- system ---
  # --------------

  networking.hostName = "mercury";
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # -----------------------
  # --- power mangement ---
  # -----------------------

  # enable suspend and hibernation
  services.logind.settings = {
    Login = {
      HandleLidSwitch = "suspend-then-hibernate";
      
      # If you used the optional external power toggle earlier, 
      # it has also been renamed to this:
      # HandleLidSwitchExternalPower = "suspend";
    };
  };

  # hibernate after 15min of suspension
  systemd.sleep.settings = {
    Sleep = {
      HibernateDelaySec = "15m";
      AllowHybridSleep = false;
    };
  };

  # cpu control
  powerManagement.enable = true;
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "schedutil";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_AC = "balance_power";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

      CPU_BOOST_ON_AC = 1;
      CPU_MAX_PERF_ON_AC = 100;

      START_CHARGE_THRESH_BAT0 = 40;
      STOP_CHARGE_THRESH_BAT0 = 80;
    };
  };

  # --------------------------
  # --- disable nvidia gpu ---
  # --------------------------

  # blacklist nvidia drivers
  boot.blacklistedKernelModules = [ 
    "nouveau" 
    "nvidia" 
    "nvidia_drm" 
    "nvidia_modeset" 
  ];

  # tell udev to immediately power down and remove the NVIDIA PCI devices
  services.udev.extraRules = ''
    # remove NVIDIA USB xHCI Host Controller devices, if present
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c0330", ATTR{power/control}="auto", ATTR{remove}="1"
    # remove NVIDIA USB Type-C UCSI devices, if present
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c8000", ATTR{power/control}="auto", ATTR{remove}="1"
    # remove NVIDIA Audio devices, if present
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", ATTR{power/control}="auto", ATTR{remove}="1"
    # remove NVIDIA VGA/3D controller devices
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", ATTR{power/control}="auto", ATTR{remove}="1"
  '';

  # ----------------
  # --- packages ---
  # ----------------

  environment.systemPackages = with pkgs; [ 
      # tools
      (pass.withExtensions (exts: [ exts.pass-otp ])) 	# password manager
      git 						# git
      git-lfs						# git for big files
      gnupg						# gpg keys
      pinentry-curses					# password prompt

      # env
      xwayland-satellite				# xwayland support
      javaPackages.compiler.temurin-bin.jre-21		# java

      # specialised software
      zed-editor					# general editor
      gimp						# image raster editor
      (stable.legacyPackages.x86_64-linux.freecad)	# CAD
      mpv						# video player
      eww						# widgets
      vesktop						# discord
      fuzzel						# application launcher
      thunar						# file manager
      xfconf
  ];

  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman  
  ];

  # ---------------
  # --- services ---
  # ----------------

  services.gvfs.enable = true; # mount, trash and some other funcs.
  services.tumbler.enable = true; # thumbnail support
}
