{ pkgs, ... }: {
  # Wireshark 抓包分析
  # dumpcap 经 security.wrappers 赋能力,普通用户即可抓包;
  # 用户需在 wireshark 组(已在 configuration.nix extraGroups)
  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };
}
