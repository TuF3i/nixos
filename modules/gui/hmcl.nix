{ pkgs, ... }: {
  # Hello Minecraft Launcher(跨平台 Minecraft 启动器,自带 JRE)
  environment.systemPackages = [ pkgs.hmcl ];
}
