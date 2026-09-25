{ ... }: {
  # Flatpak:应用框架,用于安装脱离 nixpkgs 栈分发的 GUI 应用
  # (如运行时自带的 Electron 应用);导出目录已加入 HM 的 XDG_DATA_DIRS
  services.flatpak.enable = true;
}
