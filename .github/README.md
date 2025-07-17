## my-nixos
> Documentation is available at [docs.atomazu.org](https://docs.atomazu.org) (also the best view to see what is offered)

#### To use this configuration:

1. **Add your own host**: Use the options and create your host in `hosts/` and link it in `flake/hosts.nix`
2. **Use your own hardware.nix**: You can generate it with `nixos-generate-config`, find it at `/etc/nixos`
3. **Switch to the config**: `sudo nixos-rebuild switch --flake .#your-host`

If you encounter issues or have questions about this configuration:

- **Discord:** @atomazu 
- **Email:** contact@atomazu.org
- **Website:** [atomazu.org](https://atomazu.org)

#### Also thank you to:

- [Misterio77](https://github.com/Misterio77/nix-config) for their Firefox home-manager configuration (added in [58938ac](https://github.com/atomazu/my-nixos/commit/58938ac0c5c79ee7529138a76918035a550c87a8)).
- [soramanew](https://github.com/caelestia-dots/shell) for their notification service which I used in my Quickshell setup (added in [4416187](https://github.com/atomazu/my-nixos/commit/441618721e36d41b3d52533639d6f307b1860435))
