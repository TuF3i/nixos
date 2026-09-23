{ ... }: {
  services.zerotierone = {
    enable = true;
    joinNetworks = [ "af78bf943621d14b" ];
  };

  # 与 clash-verge TUN 共存的要点:
  # 1. rp_filter 已在 clash-rev.nix 全局设为 loose,ZeroTier 的非对称路由同样依赖它
  # 2. ZeroTier 托管路由是具体网段,按最长前缀优先于 clash 的默认路由,互不劫持;
  #    切勿在 ZeroTier Central 勾选 Allow Global(接管默认路由),那才会真冲突
  # 3. 本机未启用 networking.firewall,UDP 9993 无需放行;若以后开防火墙,
  #    需为 zt* 接口和 9993 端口加规则
  # 4. 若节点间直连异常变慢(走 relay),在 Clash Verge 规则里加 DST-PORT,9993,DIRECT,
  #    避免零层的握手/打洞 UDP 被代理转发
}
