{ pkgs, ... }: {
  # Android 平台工具:adb + fastboot
  environment.systemPackages = [ pkgs.android-tools ];
}
