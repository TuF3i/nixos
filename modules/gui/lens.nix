{ pkgs, ... }: {
  # Kubernetes IDE(GUI);unfree,已由全局 allowUnfree 放行
  environment.systemPackages = [ pkgs.lens ];
}
