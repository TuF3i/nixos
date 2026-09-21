{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    (google-chrome.override {
      commandLineArgs = [
        "--enable-features=UseOzonePlatform"
        "--ozone-platform=wayland"
        "--enable-features=WaylandWindowDecorations"
        "--ozone-platform-hint=wayland"
        "--enable-wayland-ime"
        "--enable-wayland-ime --wayland-text-input-version=3"
      ];
    })
  ];
}
