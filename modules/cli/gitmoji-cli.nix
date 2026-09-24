{ pkgs, ... }: {
  # emoji 规范化 commit 消息生成器
  environment.systemPackages = [ pkgs.gitmoji-cli ];
}
