{
  lib,
}:
{
  mkEnabledOption =
    description:
    lib.mkOption {
      type = lib.types.bool;
      default = true;
      inherit description;
    };
}
