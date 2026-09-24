{ pkgs, ... }: {
  # VS Code(unfree)。
  # background 等"改安装目录文件注入"的扩展在 nix store(只读)上必然 EACCES,
  # 故包装 code:首次运行或 VSCode 升级后把应用树复制到可写缓存再启动,
  # 副本内的启动脚本改指缓存自身,Electron 从可写副本加载资源,扩展随意注入。
  # 代价:每版本约 400MB 磁盘,首次启动稍慢。
  environment.systemPackages = [
    (pkgs.symlinkJoin {
      name = "vscode";
      paths = [ pkgs.vscode ];
      postBuild = ''
        bin="$out/bin/code"
        rm "$bin"
        cat > "$bin" <<'EOF'
        #!/run/current-system/sw/bin/bash
        set -euo pipefail
        real="@vscode@/bin/code"
        out="@vscode@"
        ver="$("$real" --version | head -1)"
        cache="''${XDG_STATE_HOME:-$HOME/.local/state}/vscode-writable/$ver"
        if [ ! -x "$cache/bin/code" ]; then
          mkdir -p "$(dirname "$cache")"
          rm -rf "$cache.tmp"
          cp -r "$out/lib/vscode" "$cache.tmp"
          chmod -R u+w "$cache.tmp"
          # 副本脚本内嵌原 store 绝对路径,全部改写为缓存路径,资源从副本加载
          sed -i "s|$out|$cache|g" "$cache.tmp/bin/code"
          mv "$cache.tmp" "$cache"
        fi
        exec "$cache/bin/code" "$@"
        EOF
        sed -i "s|@vscode@|${pkgs.vscode}|g" "$bin"
        chmod +x "$bin"
      '';
    })
  ];
}
