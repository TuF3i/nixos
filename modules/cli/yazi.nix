{ pkgs, ... }: {
  # yazi:Rust 编写的终端文件管理器
  environment.systemPackages = [ pkgs.yazi ];
}
