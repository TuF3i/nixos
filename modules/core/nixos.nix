{ pkgs, ... }: {
  programs.nh = {
    enable = true;
    flake = "/home/tuf3i/nixos";
  };

  # Features
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    auto-optimise-store = true;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  # nix-ld:让 Mason 等下载的通用 Linux 动态链接二进制能运行
  # (AstroNvim 装解析器用的 tree-sitter CLI 即此类;缺 .so 时往下补 libraries)
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc # libstdc++ / libgcc
      zlib
      openssl
    ];
  };

  services.upower.enable = true;

  # DMS 电源面板依赖
  services.power-profiles-daemon.enable = true;

  # Intel 笔记本温控
  services.thermald.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # Intel 核显视频硬解
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
    ];
  };
}
