# My NixOS Configuration

This repository contains my personal NixOS configuration, built using Nix Flakes. It's an ongoing effort to learn Nix and create a setup that's organized and reusable.

## Conceptual Structure

Think of the configuration as layers that come together to define a complete system for a specific machine:

```
System Build (Flake Entry Point)
│
└─── Host Configuration (`hosts/`)
     Defines a specific machine (e.g., my desktop).
     This is the main configuration point. It:
     │
     ├── Pulls in Hardware Settings (`hosts/hardware-*.nix`)
     │   └── Machine-specific details, often auto-detected.
     │
     ├── Activates System-Wide Modules (`system/`)
     │   └── Low-level settings like graphics drivers (e.g., NVIDIA).
     │
     ├── Selects Environment Profiles (`profiles/`)
     │   └── Defines the main user experience (e.g., Cinnamon, Sway, GNOME).
     │       └── Profiles might use their own modules (e.g., Waybar for Sway).
     │
     └─── Configures the User Environment (`home/`)
         └── Manages user-specific settings via Home Manager:
             ├── Applications (e.g., Albert, Chromium)
             ├── Development tools (e.g., Git, NixVim, Tmux)
             ├── Dotfiles & Themes (e.g., Albert QSS style)
```

## How it Works

1.  The `flake.nix` file defines the inputs (like `nixpkgs`, `home-manager`) and outputs. The main outputs are the `nixosConfigurations` (e.g., `desktop`).
2.  Building a specific configuration (like `nixos-rebuild switch --flake .#desktop`) starts with the corresponding file in `hosts/` (e.g., `hosts/desktop.nix`).
3.  This host file imports common settings (`hosts/default.nix`), its specific hardware configuration (`hosts/hardware-desktop.nix`), and then activates the desired profiles, system modules, and home-manager configurations by setting options.
4.  Modules in `system/`, `profiles/`, and `home/` contain the actual Nix code that configures packages, services, settings, and dotfiles based on the options enabled in the host file.

This setup aims for modularity, allowing different machines (`hosts/`) to reuse common settings (`system/`, `profiles/`, `home/`) while having their own specific configurations.
