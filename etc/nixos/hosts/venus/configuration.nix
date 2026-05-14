{ config, pkgs, stable, awww, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules/common.nix
    ];

  # --------------
  # --- system ---
  # --------------

  networking.hostName = "venus";
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

  # vulkan
  hardware.graphics = { enable = true; enable32Bit = true; };
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.cpu.intel.updateMicrocode = true;
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false; # often causes freezes
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # ALFA AWUS036ACH Wi-Fi adapter
  #  boot.extraModulePackages = [ config.boot.kernelPackages.rtl8812au ];
  #  boot.kernelModules = [ "8812au" ]; # broken in 25.11 as of 20/03/26

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
    xwayland-satellite				        # xwayland support
    javaPackages.compiler.temurin-bin.jre-21		# java

    # specialised software
    zed-editor				         	# general editor
    gimp						# image raster editor
    (stable.legacyPackages.x86_64-linux.freecad)	# CAD
    mpv						        # video player
    eww						        # widgets
    vesktop						# discord
    fuzzel						# application launcher
    thunar						# file manager
    xfconf                                              # required for thunar
    transmission_4-gtk                                  # torrent client
    stremio-linux-shell                                 # stremio
    steam-run                                           # FHS env for games
    steam                                               # steam
    digikam                                             # image sorter
    ntfs3g						# ntfs support (temp)
 ];

 programs.thunar.plugins = with pkgs.xfce; [
   thunar-archive-plugin
   thunar-volman
 ];

 # ----------------
 # --- services ---
 # ----------------

 services.gvfs.enable = true; # Mount, trash, and other functionalities
 services.tumbler.enable = true; # Thumbnail support for images
}
