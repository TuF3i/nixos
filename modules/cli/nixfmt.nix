{ pkgs, ... }: {
  # Nix 官方 RFC 风格格式化器
  environment.systemPackages = [ pkgs.nixfmt ];
}
