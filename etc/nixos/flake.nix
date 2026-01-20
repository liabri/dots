{
  description = "NixOS configuration with Ungoogled Chromium Widevine";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    awww.url = "git+https://codeberg.org/LGFae/awww";
  };

  outputs = { self, nixpkgs, awww }: 
  let
    system = "x86_64-linux";
    
    widevineOverlay = final: prev: {
      ungoogled-chromium = final.symlinkJoin {
        name = "ungoogled-chromium-widevine-final";
        paths = [ prev.ungoogled-chromium ];
        nativeBuildInputs = [ final.makeWrapper ];

        postBuild = ''
          # 1. Source Widevine from nixpkgs
          WVPKG="${final.widevine-cdm}/share/google/chrome/WidevineCdm"
          
          # 2. Replicate structure inside the browser's own library directory
          # Most Chromium builds on Linux look here relative to the binary
          INTERNAL_LIB="$out/lib/chromium/WidevineCdm"
          mkdir -p "$INTERNAL_LIB/_platform_specific/linux_x64"
          
          cp "$WVPKG/manifest.json" "$INTERNAL_LIB/"
          cp "$WVPKG/_platform_specific/linux_x64/libwidevinecdm.so" \
             "$INTERNAL_LIB/_platform_specific/linux_x64/"
          
          # 3. Extract version for the flags
          WV_VERSION=$(cat "$WVPKG/manifest.json" | ${final.jq}/bin/jq -r .version)

          # 4. Re-wrap the binary
          # We delete the old wrapper and create a new one pointing to our Internal Lib
          rm $out/bin/chromium
          makeWrapper ${prev.ungoogled-chromium}/bin/chromium $out/bin/chromium \
            --add-flags "--widevine-cdm-path=$INTERNAL_LIB" \
            --add-flags "--widevine-cdm-version=$WV_VERSION"
        '';
      };
    };
  in {
    nixosConfigurations.liabri = nixpkgs.lib.nixosSystem {
      inherit system;
      
      # Pass inputs into configuration.nix
      specialArgs = { inherit awww; };

      modules = [
        ./configuration.nix
        ({ pkgs, ... }: {
          # Essential unfree config for Widevine
          nixpkgs.config.allowUnfree = true;

          # Apply our custom overlay
          nixpkgs.overlays = [ widevineOverlay ];

          # Ensure ungoogled-chromium is in the system packages
          environment.systemPackages = [ pkgs.ungoogled-chromium ];
        })
      ];
    };
  };
}
