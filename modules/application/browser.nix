{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    (google-chrome.override {
      commandLineArgs = [
        "--ozone-platform=wayland"
        "--enable-features=UseOzonePlatform,WaylandWindowDecorations"
        # Wayland 下 fcitx5 正常输入依赖 text-input-v3 协议
        "--enable-wayland-ime"
        "--wayland-text-input-version=3"
      ];
    })
  ];
}
