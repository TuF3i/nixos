{ pkgs, ... }: {
  # Android Studio(unfree)。首次启动让 IDE 自己下载 SDK 到 ~/Android/Sdk;
  # 模拟器硬件加速依赖 KVM(内核 kvm-intel 已加载)
  environment.systemPackages = [ pkgs.android-studio ];
}
