{ pkgs, ... }: {
  # Go 工具链 + LSP
  environment.systemPackages = with pkgs; [
    go
    gopls
  ];
}
