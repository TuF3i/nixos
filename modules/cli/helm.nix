{ pkgs, ... }: {
  # Kubernetes 包管理器;注意 nixpkgs 里 pkgs.helm 是同名合成器,别拿错
  environment.systemPackages = [ pkgs.kubernetes-helm ];
}
