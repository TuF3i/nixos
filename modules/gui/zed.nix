{ pkgs, ... }: {
  # Zed 代码编辑器
  environment.systemPackages = [ pkgs.zed-editor ];
}
