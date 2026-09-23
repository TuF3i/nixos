{ pkgs, ... }: {
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      # Wayland 环境下必须开启，以抑制环境变量警告并启用原生支持
      waylandFrontend = true;
      addons = with pkgs; [
        qt6Packages.fcitx5-chinese-addons
        fcitx5-gtk             # GTK 应用支持
        # 如使用 KDE/Qt 应用，建议加上 kdePackages.fcitx5-qt
        # kdePackages.fcitx5-qt
      ];
    };
  };
} 
