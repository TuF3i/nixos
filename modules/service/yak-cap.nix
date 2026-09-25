{ pkgs, ... }: {
  # Yakit 引擎 pcap 权限:引擎是运行时下载到 ~/.yakit 的动态二进制,
  # 无法用 security.wrappers(要求构建期 store 路径)。
  # 用 systemd path 单元监视 ~/.yakit,引擎落盘即自动赋予
  # CAP_NET_RAW/CAP_NET_ADMIN(libpcap 抓包所需),开机时也执行一遍。
  systemd.services.yak-cap = {
    description = "Grant yak engine CAP_NET_RAW for pcap";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = let
        script = pkgs.writeShellScript "yak-cap" ''
          for bin in $(find /home/tuf3i/.yakit -maxdepth 4 -type f -name "yak*" -executable 2>/dev/null); do
            ${pkgs.libcap}/bin/setcap cap_net_raw,cap_net_admin+ep "$bin" 2>/dev/null || true
          done
        '';
      in "${script}";
      RemainAfterExit = false;
    };
    wantedBy = [ "multi-user.target" ];
  };

  systemd.paths.yak-cap-watch = {
    description = "Watch yak engine downloads for cap granting";
    wantedBy = [ "multi-user.target" ];
    pathConfig = {
      PathModified = "/home/tuf3i/.yakit";
      Unit = "yak-cap.service";
    };
  };
}
