{ inputs, pkgs, ... }: {
  imports = [
    # 本机全局配置
    ./system/hardware-configuration.nix
    ./system/boot.nix
    ./system/nixos.nix
    # ./system/proxy.nix   # 临时代理,按需启用

    # CLI 工具(每个工具一个单文件,按需增删)
    ../../modules/cli/zsh.nix
    ../../modules/cli/bash.nix
    ../../modules/cli/git.nix
    ../../modules/cli/gcc.nix
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
    ../../modules/cli/mqttx-cli.nix
    ../../modules/cli/dnsutils.nix
    ../../modules/cli/ipmitool.nix

    # 数据库 CLI 与 Android 工具链
    ../../modules/cli/android-tools.nix
    ../../modules/cli/scrcpy.nix
    ../../modules/cli/yazi.nix
    # 开发环境(按语言一个单文件,按需增删)
    ../../modules/dev/platformio.nix
    ../../modules/dev/go.nix
    ../../modules/dev/rust.nix
    ../../modules/dev/c-cpp.nix
    ../../modules/dev/java.nix
    ../../modules/dev/python.nix
    ../../modules/dev/lua.nix
    ../../modules/dev/nodejs.nix

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
    ../../modules/gui/android-studio.nix
    ../../modules/gui/navicat.nix
    ../../modules/gui/redisinsight.nix
    ../../modules/gui/mongodb-compass.nix
    ../../modules/gui/yakit.nix
    ../../modules/gui/apifox.nix
    ../../modules/gui/etcd-workbench.nix
    ../../modules/gui/tabby.nix
    ../../modules/gui/termius.nix
    ../../modules/gui/hmcl.nix
    ../../modules/gui/lceda-pro.nix
    ../../modules/gui/mqttx.nix
    ../../modules/gui/imv.nix
    ../../modules/gui/peazip.nix
    ../../modules/gui/kitty.nix
    ../../modules/gui/firefox.nix
    ../../modules/gui/impression.nix
    ../../modules/gui/remmina.nix
    ../../modules/gui/tigervnc.nix

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

    # 安全工具
    ../../modules/hacker/metasploit.nix
    ../../modules/hacker/nmap.nix

    # 服务
    ../../modules/service/clash-rev.nix
    ../../modules/service/zerotier.nix
    ../../modules/service/printing.nix
    ../../modules/service/flatpak.nix
    ../../modules/service/steam.nix
    ../../modules/service/certificates.nix
    ../../modules/service/yak-cap.nix
    ../../modules/service/docker.nix
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
      "docker"
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

  nixpkgs.config = {
    allowUnfree = true;
    # RedisInsight 依赖的 Electron 版本被标记 insecure,显式放行
    permittedInsecurePackages = [ "electron-41.10.6" ];
  };
  system.stateVersion = "26.05";
}
