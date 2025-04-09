{ inputs, cell }:
let
  inherit (inputs) nixpkgs;
in
{
  module =
    nixpkgs.testers.runNixOSTest {
      name = "module";

      nodes = {
        machine =
          { ... }:
          {
            imports = [
              "${inputs.self}/module.nix"
            ];

            services.gowitness = {
              enable = true;
              debug = true;
            };

          };
      };

      testScript = ''
        machine.wait_for_unit("gowitness.service")
        machine.wait_for_open_port(7171)
      '';
    }
    // {
      meta.description = "Gowitness Module Test";
    };
}
