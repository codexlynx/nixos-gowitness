{ inputs, cell }:
let
  inherit (inputs) nixpkgs;
in
{
  default =
    nixpkgs.testers.runNixOSTest {
      name = "default";

      nodes = {
        machine =
          { ... }:
          {
            imports = [
              "${inputs.self}/module.nix"
            ];

            services.gowitness = {
              enable = true;
            };
          };
      };

      testScript = ''
        machine.wait_for_unit("gowitness.service")
        machine.wait_for_open_port(7171)

        machine.fail("journalctl -u gowitness.service | grep debug") # debug
        machine.succeed("journalctl -u gowitness.service | grep 127.0.0.1") # host
        machine.succeed("journalctl -u gowitness.service | grep 7171") # port
        machine.succeed("cat /etc/systemd/system/gowitness.service | grep User=gowitness") # user
        machine.succeed("cat /etc/systemd/system/gowitness.service | grep Group=gowitness") # group
      '';
    }
    // {
      meta.description = "Gowitness Module Test";
    };
}
