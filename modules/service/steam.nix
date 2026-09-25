{ pkgs, ... }: {
  # Steam 与 steam-run:完整 FHS 运行时(Mesa 驱动/glibc/字体/dbus 全套),
  # 供嘉立创EDA 等对宿主栈不兼容的 GUI 应用使用(unfree 已由全局放行)
  programs.steam.enable = true;
}
