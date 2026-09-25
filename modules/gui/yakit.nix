{ pkgs, ... }: {
  # Yakit 网络安全测试平台(本地打包,见 ../packfile/yakit.nix)
  environment.systemPackages = [
    (pkgs.callPackage ../packfile/yakit.nix { })
  ];
}
