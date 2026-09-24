{ pkgs, ... }: {
  # Navicat:中文社区版(本地打包,见 ../packfile/navicat-premium-lite-cs.nix)
  environment.systemPackages = [
    (pkgs.callPackage ../packfile/navicat-premium-lite-cs.nix { })
  ];
}
