{ pkgs, ... }: {
  # TigerVNC 客户端(vncviewer)
  environment.systemPackages = [ pkgs.tigervnc ];
}
