{ pkgs, ... }: {
  # Java 工具链 + 构建工具
  environment.systemPackages = with pkgs; [
    jdk
    maven
    gradle
  ];
}
