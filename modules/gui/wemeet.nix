{ pkgs, ... }: {
  # 腾讯会议(包名 wemeet)
  environment.systemPackages = [ pkgs.wemeet ];
}
