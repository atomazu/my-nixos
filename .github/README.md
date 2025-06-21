## Welcome to my NixOS configuration

Documentation is available at [atomazu.org/my-nixos](https://atomazu.org/my-nixos) (updated automatically).

To use this configuration, you can either fork the repo and add your host to `hosts/` or import the exposed `nixosModule` into your own flake.

**Note:** This configuration currently doesn't support enabling just 1 or 2 modules while leaving the rest disabled—although this is planned. Right now it configures the bootloader, stylix, locale, and more, with no way to disable this behavior.

### Usage Example

Add this as an input in your flake:

```nix
# flake.nix
{
  description = "My personal NixOS configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    atmz = {
      url = "github:atomazu/my-nixos";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, atmz, ... }@inputs: {
    nixosConfigurations.my-laptop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        atmz.nixosModules.default
        ./configuration.nix
      ];
    };
  };
}
```

Then use the options in your configuration:

```nix
# configuration.nix
{ config, pkgs, ... }:
{
  # --- Basic Host Configuration ---
  # Use the `host` options to set up the system's identity.
  host = {
    name = "my-laptop";
    user = "alice";
    locale = "en_US.UTF-8";
    time = "America/New_York";
    stylix.scheme = "catppuccin-mocha";
  };

  # --- System-level Tweaks ---
  # Use the `sys` options for bootloader, GPU, etc.
  sys = {
    boot.loader.grub.enable = true;
    # If you have an NVIDIA GPU:
    # gpu.nvidia.enable = true;
  };

  # --- Home Manager Programs ---
  # Use the `home` options to configure user applications.
  home = {
    git = {
      enable = true;
      name = "Alice";
      email = "alice@example.com";
    };
    shell.enable = true;
    nixvim.enable = true;
    tmux.enable = true;
  };

  # --- Desktop Environment / Window Manager ---
  # Enable one of the available profiles.
  profiles.sway.enable = true;

  # The rest is your normal configuration
  environment.systemPackages = with pkgs; [
    firefox
  ];

  system.stateVersion = "25.05";
}
```
For more examples you may look at the existing configurations in `hosts/`.

## Support & Contributing

### Getting Help
If you encounter issues or have questions about this configuration:

- **Discord:** @atomazu (fastest response)
- **Email:** contact@atomazu.org
- **GitHub Issues:** [Open an issue](https://github.com/atomazu/my-nixos/issues) for bugs or feature requests

### Contributing
Contributions are welcome! Please feel free to submit pull requests or open issues for discussion.
