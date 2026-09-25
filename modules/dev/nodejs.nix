{ pkgs, ... }: {
  # Node.js LTS(npm 随附)+ pnpm 包管理器
  environment.systemPackages = with pkgs; [
    nodejs_22
    pnpm
  ];
}
