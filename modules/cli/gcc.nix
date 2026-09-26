{ pkgs, ... }: {
  # GCC 编译器(C/C++ 编译、AstroNvim treesitter 解析器本地编译)
  environment.systemPackages = [ pkgs.gcc ];
}
