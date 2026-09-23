{ ... }: {
  # 系统级 zsh 基础设施(可执行文件、/etc 下的框架文件)
  # 用户 shell 配置由 home-manager 接管,见 home/shell.nix
  programs.zsh.enable = true;
}
