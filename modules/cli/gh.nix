{ pkgs, ... }: {
  # GitHub 官方 CLI
  environment.systemPackages = [ pkgs.gh ];
}
