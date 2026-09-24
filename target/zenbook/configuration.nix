{ inputs, pkgs, ... }: {
  imports = [
    # 本机全局配置
    ./system/hardware-configuration.nix
    ./system/boot.nix
    ./system/nixos.nix
    # ./system/proxy.nix   # 临时代理,按需启用

    # CLI 工具(每个工具一个单文件,按需增删)
    ../../modules/cli/zsh.nix
    ../../modules/cli/git.nix
    ../../modules/cli/neovim.nix
    ../../modules/cli/curl.nix
    ../../modules/cli/wget.nix
    ../../modules/cli/fastfetch.nix
    ../../modules/cli/btop.nix
    ../../modules/cli/eza.nix
    ../../modules/cli/tldr.nix
    ../../modules/cli/ripgrep.nix
    ../../modules/cli/fd.nix
    ../../modules/cli/unzip.nix
    ../../modules/cli/wl-clipboard.nix
    ../../modules/cli/tree-sitter.nix
    ../../modules/cli/nixd.nix
    ../../modules/cli/nil.nix
    ../../modules/cli/nixfmt.nix
    ../../modules/cli/gitmoji-cli.nix

    # 开发环境(按语言一个单文件,按需增删)
    ../../modules/dev/platformio.nix
    ../../modules/dev/go.nix
    ../../modules/dev/rust.nix
    ../../modules/dev/c-cpp.nix
    ../../modules/dev/java.nix
    ../../modules/dev/python.nix
    ../../modules/dev/lua.nix

    # Git 托管平台与 Kubernetes 工具链
    ../../modules/cli/tea.nix
    ../../modules/cli/gh.nix
    ../../modules/cli/kubectl.nix
    ../../modules/cli/kubectx.nix
    ../../modules/cli/kconf.nix
    ../../modules/cli/helm.nix

    ../../modules/cli/claude.nix
    ../../modules/cli/zcode.nix

    # GUI 应用
    ../../modules/gui/browser.nix
    ../../modules/gui/libreoffice.nix
    ../../modules/gui/lens.nix
    ../../modules/gui/zed.nix
    ../../modules/gui/vscode.nix
    ../../modules/gui/bitwarden.nix

    # 通讯与办公
    ../../modules/gui/qq.nix
    ../../modules/gui/wechat.nix
    ../../modules/gui/feishu.nix
    ../../modules/gui/wemeet.nix
    ../../modules/gui/obs.nix

    ../../modules/gui/fcitx5.nix

    # 桌面环境
    ../../modules/desktop/niri.nix
    ../../modules/desktop/dms.nix
    ../../modules/desktop/greeter.nix

    # 服务
    ../../modules/service/clash-rev.nix
    ../../modules/service/zerotier.nix
  ];

  time.timeZone = "Asia/Shanghai";

  i18n.defaultLocale = "zh_CN.UTF-8";

  networking.hostName = "zenbook";
  networking.networkmanager.enable = true;

  users.users.tuf3i = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "video"
      "dialout"
      "bluetooth"
    ];

    shell = pkgs.zsh;
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    # HM 接管已存在的文件时,把旧文件改名为 <file>.backup 而不是报错
    backupFileExtension = "backup";
    users.tuf3i = import ./home;
  };

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "26.05";
}
