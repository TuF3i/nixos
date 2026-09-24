{ pkgs, ... }: {
  # PlatformIO Core(pio 命令行,FHS 沙箱版:下载的交叉工具链开箱能跑)
  environment.systemPackages = [ pkgs.platformio ];

  # 烧录器 udev 规则(部分板子的 USB 权限);用户已在 dialout 组
  services.udev.packages = [
    (pkgs.writeTextFile {
      name = "platformio-udev-rules";
      destination = "/lib/udev/rules.d/60-platformio.rules";
      # 官方 rules:给常用烧录器的 USB 设备授予访问权限并标记 tag
      text = ''
        # PlatformIO udev rules
        SUBSYSTEM=="tty", ATTRS{idVendor}=="10c4", ATTRS{idProduct}=="ea60", MODE="0666", ENV{ID_MM_DEVICE_IGNORE}="1"
        SUBSYSTEM=="tty", ATTRS{idVendor}=="1a86", ATTRS{idProduct}=="7523", MODE="0666", ENV{ID_MM_DEVICE_IGNORE}="1"
        SUBSYSTEM=="tty", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6001", MODE="0666", ENV{ID_MM_DEVICE_IGNORE}="1"
        SUBSYSTEM=="tty", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6015", MODE="0666", ENV{ID_MM_DEVICE_IGNORE}="1"
        SUBSYSTEM=="tty", ATTRS{idVendor}=="2341", MODE="0666", ENV{ID_MM_DEVICE_IGNORE}="1"
        SUBSYSTEM=="usb", ATTRS{idVendor}=="239a", MODE="0666", ENV{ID_MM_DEVICE_IGNORE}="1"
        SUBSYSTEM=="usb", ATTRS{idVendor}=="2e8a", MODE="0666", ENV{ID_MM_DEVICE_IGNORE}="1"
        SUBSYSTEM=="usb", ATTRS{idVendor}=="2341", MODE="0666", ENV{ID_MM_DEVICE_IGNORE}="1"
        SUBSYSTEM=="usb", ATTRS{idVendor}=="1b4f", MODE="0666", ENV{ID_MM_DEVICE_IGNORE}="1"
      '';
    })
  ];
}
