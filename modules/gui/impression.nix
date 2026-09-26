{ pkgs, ... }: {
  # Impression 镜像烧录工具(Etcher 平替)
  environment.systemPackages = [ pkgs.impression ];
}
