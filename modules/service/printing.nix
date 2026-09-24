{ pkgs, ... }: {
  # 打印服务:CUPS + IPP Everywhere 免驱支持 + GTK 弹窗助手
  services.printing = {
    enable = true;
    # 现代打印机(USB/网络)走 IPP 无需额外驱动;
    # 无 drivers 元包时,厂商专用驱动可另行加入
  };

  # 桌面添加/管理打印机的 polkit 助手(之前被移除,DMS 也依赖它)
  environment.systemPackages = with pkgs; [
    cups-pk-helper
  ];
}
