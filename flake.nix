# Вспомогательный файл, полезный для пользователей nixos
{
  description = "Dev flake";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            cilium-cli
            clusterctl
            fluxcd
            kubectl
            openstackclient
          ];
        };
      }
    );
}
