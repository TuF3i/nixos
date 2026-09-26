{ pkgs, ... }:{
  environment.systemPackages = with pkgs; [
    ipmitool
  ];
}
