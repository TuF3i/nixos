{ inputs, pkgs, ... }: {
  imports = [
    ../modules/core/shell.nix
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
