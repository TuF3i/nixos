{ pkgs, ... }:{
  environment.systemPackages = with pkgs; [
     cc-switch
     claude-code
  ];
}
