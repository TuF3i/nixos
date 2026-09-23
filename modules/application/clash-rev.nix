{ ... }: {
  programs.clash-verge = {
    enable = true;

    # TUN 模式:通过 security wrapper 授予 cap_net_admin 等能力
    tunMode = true;

    # 服务模式:特权 systemd 守护进程,GUI 通过 socket 控制
    serviceMode = true;

    # 登录自启(XDG autostart)
    autoStart = true;
  };

  # TUN 模式下必须放宽反向路径校验,否则 DNS 不通
  networking.firewall.checkReversePath = "loose";
}
