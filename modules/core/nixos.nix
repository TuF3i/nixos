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
