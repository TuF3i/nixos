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
      monospace = [
        "FiraCode Nerd Font"
        # 显式指定简体变体:不指定时 fontconfig 会回退到 KR(韩文)字形,
        # 导致终端里的中文笔画风格异常
        "Noto Sans Mono CJK SC"
      ];
      sansSerif = [ "Noto Sans CJK SC" ];
    };
  };

  services.gvfs.enable = true;
  services.udisks2.enable = true;

  security.polkit.enable = true;

  # 密钥环:Electron 应用(Compass/Bitwarden 等)经 libsecret 存凭据依赖它;
  # 登录时由 greetd 的 PAM 用登录密码自动解锁
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;
  security.pam.services.dms-greeter.enableGnomeKeyring = true;
  security.pam.services.login.enableGnomeKeyring = true;
}
