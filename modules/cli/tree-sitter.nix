{ pkgs, ... }: {
  # AstroNvim treesitter 解析器本地编译所需
  environment.systemPackages = [ pkgs.tree-sitter ];
}
