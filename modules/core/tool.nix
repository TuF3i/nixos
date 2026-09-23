{ pkgs, ... }: {
  # 系统级基础工具,root 应急时也可用;用户级工具见 home/
  environment.systemPackages = with pkgs; [
    git
    wget
    curl
    neovim
  ];
}
