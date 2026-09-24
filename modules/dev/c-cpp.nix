{ pkgs, ... }: {
  # C/C++ 工具链:编译(llvm 系,clang-tools 含 clangd/clang-tidy)+ 调试 + 构建
  # gcc 在 modules/cli/gcc.nix
  environment.systemPackages = with pkgs; [
    clang-tools
    gdb
    cmake
    gnumake
    pkg-config
  ];
}
