{ pkgs, ... }: {
  # MongoDB Compass 官方 GUI(unfree)
  environment.systemPackages = [ pkgs.mongodb-compass ];
}
