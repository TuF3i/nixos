{ pkgs, ... }: {
  # VS Code(unfree)
  environment.systemPackages = [ pkgs.vscode ];
}
