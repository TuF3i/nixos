{ pkgs, ... }: {
  # GPG:提交签名
  programs.gpg.enable = true;

  services.gpg-agent = {
    enable = true;
    # 让 gpg-agent 兼任 ssh-agent(SSH 密钥的缓存/解锁统一由它管理)
    enableSshSupport = true;
    pinentry.package = pkgs.pinentry-qt;
    defaultCacheTtl = 21600; # 6h 内免重复输密码
    maxCacheTtl = 86400;
  };

  # SSH:推送认证(matchBlocks 已弃用,统一走 settings 块;
  # 内置默认项将被 HM 移除,所需项自行声明)
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "*" = {
        AddKeysToAgent = "yes";
      };
      "github.com" = {
        User = "git";
        IdentityFile = "~/.ssh/id_rsa";
      };
    };
  };
}
