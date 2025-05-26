{ config, lib, inputs, ... }:

{
  home-manager.users.${config.sys.user} = {
    imports = [
        inputs.nixvim.homeManagerModules.nixvim
        ./nixvim.nix
        ./tmux.nix
        ./vim.nix
      ];

    programs.git = {
      enable = true;
      userName = "atomazu";
      userEmail = "contact@atomazu.org";
    };

    programs.chromium = {
      enable = true;
      commandLineArgs = [
        "--ignore-gpu-blocklist"
        "--use-gl=egl"
        "--ozone-platform-hint=auto"
      ] ++ (lib.optional
      (config.sys.gpu == "nvidia")
      "--enable-features=VaapiIgnoreDriverChecks,VaapiOnNvidiaGPUs,AcceleratedVideoDecodeLinuxGL,AcceleratedVideoDecodeLinuxZeroCopyGL,AcceleratedVideoEncoder,Vulkan");

      extensions = [
        { id = "nngceckbapebfimnlniiiahkandclblb"; }
        { id = "ddkjiahejlhfcafbddmgiahcphecmpfh"; }
        { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; }
      ];
    };

    home.stateVersion = "24.11";
  };
}
