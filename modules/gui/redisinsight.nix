{ pkgs, ... }: {
  # RedisInsight:Redis 官方 GUI
  environment.systemPackages = [ pkgs.redisinsight ];
}
