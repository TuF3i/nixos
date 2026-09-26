{ pkgs, ... }: {
  # Fastfetch 系统信息展示:
  # - logo 用 kitty 图形协议渲染本地图片(data/pics/cat-1.jpg)
  # - JSON 配置经 jq 校验语法,首行 $schema 注释后写入
  xdg.configFile."fastfetch/config.jsonc" = {
    source = pkgs.runCommand "fastfetch-config.jsonc" { nativeBuildInputs = [ pkgs.jq ]; } ''
      cat <<'JSON' | jq -e . > $out
      {
        "logo": {
          "type": "kitty",
          "source": "${../../../data/pics/cat-1.jpg}",
          "height": 18
        },
        "display": {
          "separator": " : "
        },
        "modules": [
          {
            "type": "custom",
            "format": "┌────────────────────────────────────────────────────────┐"
          },
          {
            "type": "title",
            "key": "  "
          },
          {
            "type": "custom",
            "format": "└────────────────────────────────────────────────────────┘"
          },
          {
            "type": "os",
            "key": "  󰰖 OS",
            "keyColor": "red"
          },
          {
            "type": "kernel",
            "key": "  󰼼 Kernel",
            "keyColor": "red"
          },
          {
            "type": "wm",
            "format": "{2}",
            "key": "  󰆍 WM",
            "keyColor": "yellow"
          },
          {
            "type": "shell",
            "format": "{1} {4}",
            "key": "  󰘳 Shell",
            "keyColor": "blue"
          },
          {
            "type": "memory",
            "key": "  󰀚 Memory",
            "keyColor": "blue"
          },
          {
            "type": "uptime",
            "key": "  󱫐 Uptime ",
            "keyColor": "red"
          },
          {
            "type": "host",
            "key": "  󰢮 Machine",
            "format": "{name}{?vendor} ({vendor}){?}",
            "keyColor": "red"
          },
          "break",
          {
            "type": "colors",
            "paddingLeft": 2,
            "symbol": "circle"
          },
          "break"
        ]
      }
      JSON
    '';
  };
}
