{ pkgs, ... }: {
  # wayland 剪贴板(nvim 系统剪贴板互通)
  environment.systemPackages = [ pkgs.wl-clipboard ];
}
