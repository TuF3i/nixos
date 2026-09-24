{ pkgs, ... }: {
  # Lua 工具链 + LSP
  environment.systemPackages = with pkgs; [
    lua
    luarocks
    lua-language-server
  ];
}
