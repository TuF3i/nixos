{ ... }: {
  services.displayManager.dms-greeter = {
    enable = true;

    # greeter 跑在独立的 niri 实例里(programs.niri 已启用,满足模块断言)
    compositor.name = "niri";

    # 复用桌面用户的 DMS 主题与壁纸,登录界面与桌面观感一致
    configHome = "/home/tuf3i";

    logs = {
      save = true;
      path = "/tmp/dms-greeter.log";
    };
  };
}
