{ ... }: {
  # 系统 CA 信任库追加项(NixOS 声明式方式,替代 update-ca-certificates 脚本)
  # Yakit MITM 抓包根 CA:使 Chrome/Node/curl 等系统证书消费者信任 Yakit 解密流量;
  # Firefox 使用独立证书库,需在其设置中另行导入
  security.pki.certificates = [
    (builtins.readFile ./certs/yak-mitm-ca.crt)
  ];
}
