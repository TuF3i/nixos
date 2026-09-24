{ pkgs, ... }: {
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
}
