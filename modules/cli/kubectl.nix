{ pkgs, ... }: {
  # Kubernetes 集群 CLI
  environment.systemPackages = [ pkgs.kubectl ];
}
