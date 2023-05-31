{
  description = "Go libraries for interacting with Hashicorp Vault";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    devenv.url = "github:cachix/devenv";
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.devenv.flakeModule
      ];

      systems = [ "x86_64-linux" "x86_64-darwin" "aarch64-darwin" ];

      perSystem = { config, self', inputs', pkgs, system, ... }: {
        devenv.shells.default = {
          languages = {
            go.enable = true;
          };

          services = {
            vault.enable = true;
          };

          packages = with pkgs; [
            golangci-lint
          ];

          scripts = {
            versions.exec = ''
              go version
              golangci-lint version
            '';
          };

          enterShell = ''
            versions
          '';
        };
      };
    };
}
