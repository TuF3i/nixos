{ pkgs, ... }: {
  # kubectl 上下文/命名空间切换(含 kubens)
  environment.systemPackages = [ pkgs.kubectx ];
}
