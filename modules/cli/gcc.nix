{ pkgs, ... }: {
  # AstroNvim treesitter 编译依赖
  environment.systemPackages = [ pkgs.gcc ];
}
