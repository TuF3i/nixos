{ ... }: {
  programs.git = {
    enable = true;

    settings = {
      user.name = "TuF3i";
      user.email = "13759301652@163.com";

      init.defaultBranch = "main";
      push.autoSetupRemote = true;

      # 声明式 credential helper:git 全局配置是 HM 只读文件,
      # gh/tea 无法运行时写入,helper 直接在此声明,工具只管认证
      credential = {
        "https://github.com".helper = "!gh auth git-credential";
        "https://git.lan.tuf3i.cc".helper = "tea login helper";
        "https://git.tuf3i.cc".helper = "tea login helper";
        "https://git.redrock.team".helper = "tea login helper";
      };
    };

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
  # 二进制等工具来自 modules/cli/ 单文件模块,EDITOR 已在 shell.nix 设置
  # nixd 的设置经编辑器 LSP 传入(见 nvim 的 lua/plugins/nix.lua)
}
