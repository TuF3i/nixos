{ pkgs, ... }: {
  programs.git = {
    enable = true;

    settings = {
      user.name = "TuF3i";
      user.email = "tuf3i.do@outlook.com";

      init.defaultBranch = "main";
      push.autoSetupRemote = true;
    };

    # 生成 GPG 密钥后:gpg --list-secret-keys --keyid-format=long 取 Key ID,
    # 填入下面并取消注释,再 nh os switch
    signing = {
      key = "6145C78DBD70F5C2";
      signByDefault = true;
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };

  # nvim 配置(~/.config/nvim)由 AstroNvim 模板手动管理,不走 HM;
  # 二进制来自系统层 tool.nix,EDITOR 已在 shell.nix 设置
  # nixd 的设置经编辑器 LSP 传入(见 nvim 的 lua/plugins/nix.lua),无需配置文件

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
    nixfmt
    gitmoji-cli

    # treesitter CLI(nix 原生版,解析器编译的后备路径)
    tree-sitter
  ];
}
