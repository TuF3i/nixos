{ pkgs, ... }: {
  # 飞书。原包是 AppImage 提取,LD_LIBRARY_PATH 锁死在自带目录,看不见系统
  # libpipewire → Electron 的屏幕采集(经 portal/PipeWire)初始化失败,会议里共享不了屏幕。
  # 用 symlinkJoin 覆盖入口脚本,注入 pipewire 库路径;feishu 命令一并补上。
  environment.systemPackages = [
    (pkgs.symlinkJoin {
      name = "feishu";
      paths = [ pkgs.feishu ];
      postBuild = ''
        bin="$out/bin/bytedance-feishu"
        rm "$bin"
        cat > "$bin" <<'EOF'
        #!/run/current-system/sw/bin/bash
        export LD_LIBRARY_PATH="@pw@/lib''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
        exec "@real@/bin/bytedance-feishu" "$@"
        EOF
        sed -i "s|@pw@|${pkgs.pipewire}|; s|@real@|${pkgs.feishu}|" "$bin"
        chmod +x "$bin"
        ln -sf bytedance-feishu "$out/bin/feishu"
      '';
    })
  ];
}
