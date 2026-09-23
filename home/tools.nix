{ pkgs, ... }: {
  programs.git = {
    enable = true;

    settings = {
      user.name = "TuF3i";
      user.email = "tuf3i.do@outlook.com";

      init.defaultBranch = "main";
      push.autoSetupRemote = true;
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };

  # nvim 配置(~/.config/nvim)由 AstroNvim 模板手动管理,不走 HM;
  # 二进制来自系统层 tool.nix,EDITOR 已在 shell.nix 设置

  # nixd LSP:格式化走 nixfmt(RFC 风格,与官方一致)
  home.file.".config/nixd/config.json".text = builtins.toJSON {
    formatting = { command = [ "nixfmt" ]; };
  };

  home.packages = with pkgs; [
    fastfetch
    btop
    eza
    tldr
    ripgrep
    fd

    # AstroNvim 运行环境:treesitter 编译 / 插件解压 / wayland 剪贴板
    gcc
    unzip
    wl-clipboard

    # Nix 开发体验:LSP + 格式化
    nixd
    nixfmt-rfc-style
    gitmoji-cli

    # treesitter CLI(nix 原生版,解析器编译的后备路径)
    tree-sitter
  ];
}
