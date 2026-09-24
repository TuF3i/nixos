{ pkgs, ... }: {
  # Nix LSP(设置经编辑器传入,见 nvim 的 lua/plugins/nix.lua)
  environment.systemPackages = [ pkgs.nixd ];
}
