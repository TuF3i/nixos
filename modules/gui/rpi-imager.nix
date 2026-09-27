{ pkgs, ... }: {
  # Raspberry Pi 官方镜像烧录工具
  environment.systemPackages = [ pkgs.rpi-imager ];
}
