{ pkgs, ... }: {
  # Bitwarden 密码管理器桌面端(注意包名是 bitwarden-desktop,CLI 叫 bitwarden-cli)
  environment.systemPackages = [ pkgs.bitwarden-desktop ];
}
