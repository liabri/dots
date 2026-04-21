{ config, pkgs, stable, awww, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules/common.nix
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
#  boot.extraModulePackages = [ config.boot.kernelPackages.rtl8812au ];
#  boot.kernelModules = [ "8812au" ]; # broken in 25.11 as of 20/03/26

  networking.hostName = "venus";

  environment.systemPackages = with pkgs; [
    steam
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
}
