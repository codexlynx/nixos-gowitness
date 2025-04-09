{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixago = {
      url = "github:nix-community/nixago";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    n2c.url = "github:nlewo/nix2container";

    std = {
      url = "github:divnix/std";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.devshell.follows = "devshell";
      inputs.nixago.follows = "nixago";
      inputs.n2c.follows = "n2c";
    };
  };

  outputs =
    { nixpkgs, std, ... }@inputs:
    let
      pkgs = import nixpkgs { system = "x86_64-linux"; };
    in
    std.growOn
      {
        inherit inputs;

        cellsFrom = ./cells;

        cellBlocks = [
          (std.blockTypes.nixostests "tests" { ci.run = true; })
        ];
      }
      {
        formatter."x86_64-linux" = pkgs.nixfmt-rfc-style;

        nixosModules.default = import ./module.nix { };
      };
}
