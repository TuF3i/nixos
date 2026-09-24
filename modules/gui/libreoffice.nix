{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # GTK 构建,自动跟随系统主题与光标;UI 语言跟随系统 locale(zh_CN)
    libreoffice
  ];
}
