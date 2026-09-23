{ ... }: {
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
}
