{ pkgs, ... }: {
  # Termius SSH 客户端(unfree)
  environment.systemPackages = [ pkgs.termius ];
}
