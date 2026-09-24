{ pkgs, ... }: {
  # 微信原生 Linux 版(wechat-uos 是旧 UOS 变体,勿混用)
  environment.systemPackages = [ pkgs.wechat ];
}
