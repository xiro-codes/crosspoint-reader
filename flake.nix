{
  description = "CrossPoint Reader Development Environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        buildScript = pkgs.writeShellScriptBin "build" ''
          echo "Building firmware..."
          pio run "$@"
        '';

        flashScript = pkgs.writeShellScriptBin "flash" ''
          echo "Flashing firmware..."
          pio run -t upload "$@"
        '';

        flashFsScript = pkgs.writeShellScriptBin "flash-fs" ''
          echo "Flashing filesystem..."
          pio run -t uploadfs "$@"
        '';

        monitorScript = pkgs.writeShellScriptBin "monitor" ''
          echo "Starting debugging monitor..."
          python3 scripts/debugging_monitor.py "$@"
        '';

        cleanScript = pkgs.writeShellScriptBin "clean" ''
          echo "Cleaning build artifacts..."
          pio run -t clean "$@"
        '';

      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            platformio
            python3
            python3Packages.pyserial
            python3Packages.colorama
            python3Packages.matplotlib
            clang-tools
            cppcheck
          ];

          shellHook = ''
            echo "🔧 CrossPoint Reader Nix Dev Environment"
            echo ""
            echo "Available commands:"
            echo "  build    - Build the firmware"
            echo "  flash    - Flash the firmware"
            echo "  flash-fs - Flash the filesystem"
            echo "  monitor  - Run the debugging monitor"
            echo "  clean    - Clean build artifacts"
            echo ""
            echo "You can pass additional arguments to any command (e.g., 'flash --upload-port /dev/ttyUSB0')"
          '';
        };

        apps = {
          build = flake-utils.lib.mkApp { drv = buildScript; };
          flash = flake-utils.lib.mkApp { drv = flashScript; };
          flash-fs = flake-utils.lib.mkApp { drv = flashFsScript; };
          monitor = flake-utils.lib.mkApp { drv = monitorScript; };
          clean = flake-utils.lib.mkApp { drv = cleanScript; };
        };
      }
    );
}
