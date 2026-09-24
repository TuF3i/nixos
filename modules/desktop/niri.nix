{ pkgs, ... }: {
  programs.niri.enable = true;

  # niri(26.04+)检测到该包会自动启动 Xwayland 兼容层并设置 DISPLAY,
  # 微信/飞书等 X11 应用依赖它,缺失时启动即崩
  environment.systemPackages = [
    pkgs.xwayland-satellite
  ];
}
