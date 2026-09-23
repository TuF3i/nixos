{ ... }:{
  systemd.services.nix-daemon.environment = {
    # 临时代理地址,启用本模块前先确认
    HTTP_PROXY = "http://172.22.160.172:7897";
    HTTPS_PROXY = "http://172.22.160.172:7897";
  };
}
