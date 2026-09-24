{ ... }: {
  programs.git = {
    enable = true;

    settings = {
      user.name = "TuF3i";
      user.email = "tuf3i.do@outlook.com";

      init.defaultBranch = "main";
      push.autoSetupRemote = true;
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
