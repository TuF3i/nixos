{ pkgs, ... }: {
  # Etcd Workbench(Tauri 应用,本地打包,见 ../packfile/etcd-workbench.nix)
  environment.systemPackages = [
    (pkgs.callPackage ../packfile/etcd-workbench.nix { })
  ];
}
