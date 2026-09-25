{ pkgs, ... }: {
  # Apifox API 开发平台(本地打包,见 ../packfile/apifox.nix)
  environment.systemPackages = [
    (pkgs.callPackage ../packfile/apifox.nix { })
  ];
}
