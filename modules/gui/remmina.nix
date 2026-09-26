{ pkgs, ... }: {
  # Remmina:多协议远程桌面客户端(VNC/RDP/SPICE/SSH)
  environment.systemPackages = [ pkgs.remmina ];
}
