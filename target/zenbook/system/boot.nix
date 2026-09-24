{ config, pkgs, ... }: {
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };

    grub = {
      efiSupport = true;
      device = "nodev";
      # /boot 分区不大,限制保留的旧 generation 数量
      configurationLimit = 10;
    };
  };

  # 开机动画:catppuccin mocha(与桌面配色一致)
  boot.plymouth = {
    enable = true;
    theme = "catppuccin-mocha";
    themePackages = [
      (pkgs.catppuccin-plymouth.override { variant = "mocha"; })
    ];
  };

  # i915 前移到 initrd,核显尽早接管输出,动画才不会晚到/先闪文字
  boot.initrd.kernelModules = [ "i915" ];

  # 静默内核日志,配合动画
  boot.kernelParams = [ "quiet" ];

  # OBS 虚拟摄像头:飞书/腾讯会议的屏幕采集在 Wayland 下不可用,
  # 由 OBS 采集桌面(走 PipeWire/portal)输出到 v4l2loopback 虚拟摄像头,
  # 会议软件直接选 "OBS Virtual Camera" 作为摄像头即可共享屏幕内容
  boot.extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
  boot.kernelModules = [ "v4l2loopback" ];
  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=10 card_label="OBS Virtual Camera" exclusive_caps=1
  '';
}
