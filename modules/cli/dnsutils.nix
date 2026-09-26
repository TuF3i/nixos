{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    bind.dnsutils
  ];
}
