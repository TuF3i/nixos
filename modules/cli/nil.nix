{ pkgs, ... }: {
  # Nix LSP(nixd 之外的另一选择;nvim 当前用的是 nixd,两者可共存)
  environment.systemPackages = [ pkgs.nil ];
}
