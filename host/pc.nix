{ inputs, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix

    ../modules/core/shell.nix
    ../modules/core/boot.nix
    ../modules/core/nixos.nix
    ../modules/core/tool.nix
    # ../modules/core/proxy.nix

    ../modules/application/browser.nix
    ../modules/application/terminal.nix
    ../modules/application/claude.nix
    ../modules/application/zcode.nix
    ../modules/application/fcitx5.nix

    ../modules/desktop/dms.nix
    ../modules/desktop/niri.nix

    ../modules/service/mihomo.nix
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
    users.tuf3i = import ../home/tuf3i.nix;
  };

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "26.05";
}
