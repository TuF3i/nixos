{ pkgs, ... }: {
  programs.nh = {
    enable = true;
  };

  # Features
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
}
