{ pkgs, ... }: {
  # OBS 直播/录屏
  environment.systemPackages = [ pkgs.obs-studio ];
}
