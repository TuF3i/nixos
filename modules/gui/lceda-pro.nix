{ pkgs, ... }: {
  # 嘉立创EDA专业版(本地打包,见 ../packfile/lceda-pro.nix;
  # zip 需手动下载到 ~/Downloads/,更新版本时同步改 packfile 的 src 与 version)
  environment.systemPackages = [
    (pkgs.callPackage ../packfile/lceda-pro.nix { })
  ];
}
