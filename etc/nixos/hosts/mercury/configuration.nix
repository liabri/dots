{ config, pkgs, stable, awww, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules/common.nix
    ];

  networking.hostName = "mercury";

  environment.systemPackages = with pkgs; [
      brightnessctl	# brightness control
 ];
}
