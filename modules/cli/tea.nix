{ pkgs, ... }: {
  # Gitea 官方 CLI
  environment.systemPackages = [ pkgs.tea ];
}
