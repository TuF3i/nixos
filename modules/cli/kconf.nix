{ pkgs, ... }: {
  # kubeconfig 多配置管理器
  environment.systemPackages = [ pkgs.kconf ];
}
