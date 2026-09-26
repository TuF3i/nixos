{ pkgs, ... }:{
  environment.systemPackages = with pkgs; [
    mqttx
  ];
}
