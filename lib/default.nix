{
  lib,
}:
{
  mkEnableOption =
    description: default:
    lib.mkOption {
      type = lib.types.bool;
      default = default;
      inherit description;
    };
}
