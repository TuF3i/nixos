{ pkgs, ... }: {
  # bash:nixpkgs 5.3p15,显式声明保证 /run/current-system/sw/bin/bash 常在
  # (多数 Electron 包装脚本的 shebang 依赖它)
  environment.systemPackages = [ pkgs.bash ];
}
