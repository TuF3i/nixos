{ pkgs, ... }: {
  # Firefox 浏览器
  environment.systemPackages = [ pkgs.firefox ];
}
