{ pkgs, inputs, ... }:{
  nixpkgs.overlays = [ inputs.llm-agents.overlays.shared-nixpkgs ];
  environment.systemPackages = [
    pkgs.llm-agents.zcode
  ];
}
