{ pkgs, ... }: {
  # Metasploit Framework 渗透测试框架(unfree)
  # 使用时数据库可接 PostgreSQL:msfdb init
  environment.systemPackages = [ pkgs.metasploit ];
}
