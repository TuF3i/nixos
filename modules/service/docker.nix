{ pkgs, ... }: {
  # Docker 引擎 + CLI(docker 29.8)
  virtualisation.docker.enable = true;

  # Docker Compose v2 插件:本版 NixOS 无 enableComposePlugin 选项,
  # 用 tmpfiles 把 docker-compose 链接进 Docker CLI 的插件搜索路径
  # (/usr/local/lib/docker/cli-plugins),提供 `docker compose` 子命令
  systemd.tmpfiles.rules = [
    "L+ /usr/local/lib/docker/cli-plugins/compose - - - - ${pkgs.docker-compose}/libexec/docker/cli-plugins/docker-compose"
  ];
}
