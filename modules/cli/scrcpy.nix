{ pkgs, ... }: {
  # scrcpy:Android 设备屏幕镜像与控制(配合 adb 使用)
  environment.systemPackages = [ pkgs.scrcpy ];
}
