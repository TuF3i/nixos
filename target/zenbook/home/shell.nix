{ pkgs, ... }: {
  programs.zsh = {
    enable = true;

    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      # theme 留空,提示符由下面的 powerlevel10k 插件接管
    };

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        # Tab 补全变成 fzf 菜单;需在 compinit(oh-my-zsh 完成)之后加载
        name = "fzf-tab";
        src = pkgs.zsh-fzf-tab;
        file = "share/fzf-tab/fzf-tab.plugin.zsh";
      }
    ];

    # p10k 配置由 `p10k configure` 生成在 ~/.p10k.zsh(非 HM 管理),必须显式
    # source,否则 p10k 找不到已保存的配置,每个新终端都会启动配置向导
    initContent = ''
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
    '';

    history = {
      size = 10000;
      save = 10000;
      ignoreDups = true;
      share = true;
    };

    # PlatformIO penv(VSCode 扩展管理)加入终端 PATH;前置使其 pio 优先生效
    envExtra = ''
      if [ -d "$HOME/.platformio/penv/bin" ]; then
        export PATH="$HOME/.platformio/penv/bin:$PATH"
      fi
    '';
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.fzf.enable = true;

  # eza(ls 替代品)图标化:目录/文件类型图标,依赖终端 Nerd Font(已具备)
  programs.zsh.shellAliases = {
    ls = "eza --icons=auto --group-directories-first";
    ll = "eza -la --icons=auto --group-directories-first --git";
    lt = "eza --tree --icons=auto --level=2";
    # nvim 配置由 AstroNvim 管理(HM 不接管),vi/vim 转到 nvim
    vi = "nvim";
    vim = "nvim";
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    # niri 以这两个变量作为合成器默认光标主题/大小
    XCURSOR_THEME = "catppuccin-mocha-dark-cursors";
    XCURSOR_SIZE = "24";
    # Flatpak 应用导出的 .desktop 目录;前置追加而非覆盖,
    # 保留 /run/current-system/sw/share(dbus 激活文件、图标等依赖它)
    XDG_DATA_DIRS = "/var/lib/flatpak/exports/share:\${XDG_DATA_DIRS:-/run/current-system/sw/share:/usr/local/share:/usr/share}:\${HOME}/.local/share/flatpak/exports/share";
  };
}
