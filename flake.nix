{
  # For more information, see: https://github.com/DavHau/mach-nix/blob/master/examples.md
  description = "A template for a python (mach-nix) project";

  inputs = {
    mach-nix.url = "mach-nix/3.5.0";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = {self, nixpkgs, mach-nix }@inputs:
    let
      l = nixpkgs.lib // builtins;
      supportedSystems = [ "x86_64-linux" ];
      forAllSystems = f: l.genAttrs supportedSystems
        (system: f system (import nixpkgs {inherit system;}));
    in
    {
      # enter this python environment by executing `nix shell .`
      devShell = forAllSystems (system: pkgs: mach-nix.lib."${system}".mkPythonShell {
        #requirements = builtins.readFile ./requirements.txt;
        requirements = ''
          pillow
          numpy
          requests
        '';
      });
    };
}
