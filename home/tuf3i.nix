{ ... }: {
  home.username = "tuf3i";
  home.homeDirectory = "/home/tuf3i";

  # 标准用户目录(XDG user dirs);文件管理器侧栏与"下载/文档"等定位依赖它
  xdg.userDirs = {
    enable = true;
    createDirectories = true;

    desktop = "$HOME/Desktop";
    documents = "$HOME/Documents";
    download = "$HOME/Downloads";
    music = "$HOME/Music";
    pictures = "$HOME/Pictures";
    videos = "$HOME/Videos";
    publicShare = "$HOME/Public";
    templates = "$HOME/Templates";
  };

  # 已安装后不要改动此值
  home.stateVersion = "26.05";

  imports = [
    ./shell.nix
    ./tools.nix
    ./apps.nix
  ];
}
