{ config, pkgs, sources, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../modules/common.nix
    ];

  # --------------
  # --- system ---
  # --------------

  networking.hostName = "mars";
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_LTS;
  boot.tmp.cleanOnBoot = true;   # wipe out temporary junk on every single boot
  boot.loader.systemd-boot.configurationLimit = 2; # keeps only the current and previous boot entry
  boot.kernel.sysctl = {
    "vm.swappiness" = 100;
    "vm.vfs_cache_pressure" = 150;
  };

  # mandatory 2GB RAM Lifesavers
  zramSwap.enable = true;
  zramSwap.algorithm = "zstd";

  hardware.enableRedistributableFirmware = true;
  hardware.cpu.intel.updateMicrocode = true;
  hardware.bluetooth.enable = false;
  hardware.graphics.enable32Bit = false;   # disable 32-bit bloat
  hardware.graphics.extraPackages = [ pkgs.intel-vaapi-driver ];

  xdg.portal.extraPortals = pkgs.lib.mkForce [ pkgs.xdg-desktop-portal-gtk ];

  # ----------------
  # --- packages ---
  # ----------------

  environment.systemPackages = with pkgs; [
      git 						# git
      mpv						# video player
      ytfzf                     # youtube searching (w sixel)
      yt-dlp                    # youtube streaming
      chafa                     # sixel support for ytfzf
      gemini-cli                # cli client for gemini

      fira-code
      fira-go
  ];

  programs.firefox = {
    enable = true;
    policies = {
      # force install uBlock Origin to block RAM-heavy ads
      ExtensionSettings = {
        "uBlock0@raymondhill.net" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
        };
      };

      # hardcore ram-saving preferences
      Preferences = {
        "dom.ipc.processCount" = 1; # Force Firefox to use only 1 process for all tabs
        "dom.ipc.processCount.extension" = 1; # Restrict extensions to 1 process
        "browser.cache.disk.enable" = false; # Save your tiny 16GB drive from cache wear
        "browser.low_commit_space_threshold_mb" = 1200; # Aggressively sleep background tabs
      };
    };
  };

  # -------------------
  # --- environment ---
  # -------------------

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "i965"; # forces the system to use the correct legacy video decoding driver
  };

  environment.shellAliases = {
    # Search YouTube with crisp SIXEL thumbnails, using Chafa & Hardware decoding
    yt = "ytfzf -t -T chafa --opts='--hwdec=vaapi'";

    ai = "gemini-cli";
    search = "firefox --new-window https://html.duckduckgo.com";
  };

  # optimized for celeron 2955U
  environment.etc."mpv/mpv.conf".text = ''
    # --- Video & Hardware Acceleration ---
    vo=gpu
    gpu-context=wayland
    hwdec=vaapi
    hwdec-codecs=all

    # --- Strict RAM & Cache Management (Crucial for 2GB) ---
    cache=yes
    demuxer-max-bytes=50MiB
    demuxer-max-back-bytes=5MiB

    # --- Stream Quality & Codec Enforcement ---
    # Forces 1080p H.264 (avc1) so your GPU handles the decoding workload
    ytdl-format="bv[height<=1080][vcodec^=avc1]+ba/b / bv[height<=1080]+ba/b / b"

    # --- Performance Tweaks ---
    framedrop=yes
    profile=fast

    # --- Interface ---
    border=no
    osc=yes
  '';

  # ---------------
  # --- services ---
  # ----------------

  services.openssh.enable = false;
  services.earlyoom.enable = true; # prevents linux locking up during ram spikes
  services.pipewire.alsa.support32Bit = false;
  services.pipewire.jack.enable = false; # drops unused jack emulation layers
  services.journald.extraConfig = "SystemMaxUse=50M";   # limit systemd log sizes aggressively to minimise space

  # -----------------
  # --- nix stuff ---
  # -----------------

  # prevents the Nix compiler from crashing the machine during updates
  nix.settings.max-jobs = 1;
  nix.settings.cores = 1;

  # auto-gc safety triggers if disk space runs critically low during builds
  nix.settings.min-free = 1000000000; # 1GB (represented in bytes)
  nix.settings.max-free = 2000000000; # 2GB

  nix.settings = {
    auto-optimise-store = true;
    keep-outputs = false;
    keep-derivations = false;
    keep-build-log = false;
    compress-build-log = true;
  };

  documentation = {
    enable = false;
    doc.enable = false;
    man.enable = false;
    info.enable = false;
    nixos.enable = false;
  };

  # make common's weekly cleaner to be a daily, ruthless cleaner
  systemd.timers.nix-clean-up.timerConfig.OnCalendar = pkgs.lib.mkForce "daily";
  systemd.services.nix-clean-up.script = pkgs.lib.mkForce ''
      ${pkgs.nix}/bin/nix-env --profile /nix/var/nix/profiles/system --delete-generations +1
      ${pkgs.nix}/bin/nix-env --profile /nix/var/nix/profiles/per-user/liabri/profile --delete-generations +1
      ${pkgs.nix}/bin/nix-collect-garbage
  '';
}
