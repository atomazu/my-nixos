{
  description = "atomazu's configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ashell = {
      url = "github:MalpenZibo/ashell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ nixpkgs, ... }:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      system = "x86_64-linux";
      libutils = import ./lib { lib = nixpkgs.lib; };
    in
    {
      nixosConfigurations = {
        desktop = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs libutils;
          };
          modules = [
            ./hosts/desktop
          ];
        };
        server = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs libutils;
          };
          modules = [
            ./hosts/server
          ];
        };
      };

      packages.${system} = {
        # Generate separate documentation files for each custom prefix
        nixos-options =
          let
            eval = inputs.self.nixosConfigurations.desktop;
            customPrefixes = [
              "sys"
              "host"
              "home"
              "profiles"
            ];

            # Recursively collect options for a specific prefix
            collectOptionsForPrefix =
              targetPrefix: prefix: opts:
              if opts._type or null == "option" then
                let
                  pathParts = nixpkgs.lib.splitString "." prefix;
                  firstPart = builtins.head pathParts;
                in
                # Only match if the first part is exactly the target prefix
                if firstPart == targetPrefix then { ${prefix} = opts; } else { }
              else if builtins.isAttrs opts then
                nixpkgs.lib.foldl (acc: item: acc // item) { } (
                  builtins.attrValues (
                    builtins.mapAttrs (
                      name: value:
                      let
                        newPrefix = if prefix == "" then name else "${prefix}.${name}";
                        # Only recurse if we're still on the right path
                        pathParts = nixpkgs.lib.splitString "." newPrefix;
                        firstPart = builtins.head pathParts;
                      in
                      if firstPart == targetPrefix then collectOptionsForPrefix targetPrefix newPrefix value else { }
                    ) (builtins.removeAttrs opts [ "_module" ])
                  )
                )
              else
                { };

            # Generate documentation for each prefix
            generateDocsForPrefix =
              prefix:
              let
                filteredOptions = collectOptionsForPrefix prefix "" eval.options;
                optionsDoc = pkgs.nixosOptionsDoc {
                  options = filteredOptions;
                  transformOptions =
                    opt:
                    opt
                    // {
                      declarations = map toString opt.declarations;
                    };
                };
              in
              pkgs.writeTextFile {
                name = "${prefix}.md";
                text = builtins.readFile optionsDoc.optionsCommonMark;
              };

            # Create a derivation that contains all the markdown files
            allDocs = pkgs.runCommand "nixos-options-docs" { } ''
              mkdir -p $out
              ${nixpkgs.lib.concatMapStringsSep "\n" (prefix: ''
                cp ${generateDocsForPrefix prefix} $out/${prefix}.md
              '') customPrefixes}
            '';
          in
          allDocs;

        # Build documentation with mdbook
        docs = pkgs.stdenv.mkDerivation {
          pname = "atomazu-config-docs";
          version = "0.1.0";
          src = ./docs;
          nativeBuildInputs = [ pkgs.mdbook ];

          buildPhase = ''
            runHook preBuild

            # Copy all generated options documentation files
            cp ${inputs.self.packages.${system}.nixos-options}/*.md src/

            mdbook build
            runHook postBuild
          '';

          installPhase = ''
            runHook preInstall
            mv book $out
            runHook postInstall
          '';
        };

        # Generate options files for CI/development
        generate-options = pkgs.writeShellScriptBin "generate-options" ''
          echo "Generating options documentation..."
          STORE_PATH=$(${pkgs.nix}/bin/nix build .#nixos-options --no-link --print-out-paths)

          # Copy all generated markdown files
          cp "$STORE_PATH"/*.md docs/src/

          echo "Generated documentation files in docs/src/:"
          ls -la docs/src/*.md
        '';
      };

      devShells.${system} = {
        docs = pkgs.mkShell {
          packages = [
            pkgs.mdbook
            inputs.self.packages.${system}.generate-options
          ];
          shellHook = ''
            echo "Welcome to the docs dev shell!"
            echo ""
            echo "Available commands:"
            echo "  generate-options  - Generate fresh options documentation"
            echo "  mdbook serve      - Serve docs locally (run in ./docs directory)"
            echo "  mdbook build      - Build docs (run in ./docs directory)"
          '';
        };
      };
    };
}
