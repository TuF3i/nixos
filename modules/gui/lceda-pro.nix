{ pkgs, ... }: {
  # 嘉立创EDA专业版(本地打包,steam-run 运行时,见 ../packfile/lceda-pro-old.nix)
  environment.systemPackages = [
    (pkgs.callPackage ../packfile/lceda-pro-old.nix { })
  ];
}
