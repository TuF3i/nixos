{ pkgs, ... }: {
  # PlatformIO:pio 命令行不走 nix 包,由 VSCode PlatformIO IDE 扩展管理的
  # ~/.platformio/penv 提供(HM shell.nix 已把 penv/bin 加进 PATH)。
  # 基底解释器 python3 由 modules/dev/python.nix 提供(需一并导入);
  # 下载的工具链为通用 Linux 二进制,由 nix-ld 负责运行。
  # 这里只提供:udev 烧录规则(用户已在 dialout 组)
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
