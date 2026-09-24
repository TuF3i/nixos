{ pkgs, ... }: {
  # 飞书
  environment.systemPackages = [ pkgs.feishu ];
}
