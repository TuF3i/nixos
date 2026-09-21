{ inputs, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix

    ../modules/core/shell.nix
    ../modules/core/boot.nix
    ../modules/core/nixos.nix
    ../modules/core/tool.nix

    ../modules/application/browser.nix
    ../modules/application/terminal.nix

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

    packages = with pkgs; [ ];
  };

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "26.05";
}
