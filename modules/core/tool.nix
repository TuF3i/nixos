{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    fzf
    neovim
    git
    wget
    curl
  ];
}
