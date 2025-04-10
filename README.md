# nixos-gowitness
[![CI](https://github.com/codexlynx/nixos-gowitness/actions/workflows/std.yml/badge.svg)](https://github.com/codexlynx/nixos-gowitness/actions/workflows/std.yml)

An NixOS module for [gowitness](https://github.com/sensepost/gowitness), a web screenshot service from Orange Cyberdefense ([sensepost](https://sensepost.com/)).

### Usage example:
```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    gowitness.url = "github:codexlynx/nixos-gowitness";
  };

  outputs = { self, nixpkgs, gowitness }:
    {
      nixosConfigurations.default = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          gowitness.nixosModules.default
          {
            system.stateVersion = "25.05";

            users = {
              mutableUsers = false;
              users.root.password = "";
            };

            services.gowitness.enable = true;
          }
        ];
      };
    };
}
```

```sh
$ nix run .\#nixosConfigurations.default.config.system.build.vm
```

### Run test:
```sh
$ nix run github:divnix/std#std -- //gowitness/tests/default:run
```

