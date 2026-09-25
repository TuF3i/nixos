{ pkgs, ... }: {
  # Tabby 终端(本地打包,见 ../packfile/tabby.nix)
  environment.systemPackages = [
    (pkgs.callPackage ../packfile/tabby.nix { })
  ];
}
