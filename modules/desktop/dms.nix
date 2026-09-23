{ pkgs, ... }: {
  programs.dms-shell = {
    enable = true;

    systemd = {
      enable = true;
      restartIfChanged = true;
    };

    enableVPN = true;
    enableDynamicTheming = true;
    enableAudioWavelength = true;
    enableCalendarEvents = true;
  };

  environment.systemPackages = with pkgs; [
    papirus-icon-theme
    adwaita-icon-theme
    hicolor-icon-theme

    nautilus
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code

    # zh_CN 环境必需:中文字体与 emoji,否则中文渲染为豆腐块
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
  ];

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      monospace = [ "FiraCode Nerd Font" ];
    };
  };

  services.gvfs.enable = true;
  services.udisks2.enable = true;

  security.polkit.enable = true;
}
