# nixos

TuF3i 的 NixOS 配置,单主机 `zenbook`(华硕笔记本,Intel 平台)。
基于 NixOS unstable + home-manager。

## 结构

```
flake.nix                     # 入口:inputs 与 nixosConfigurations.zenbook
host/
  pc.nix                      # 主机配置:用户、时区、网络,接入所有模块与 home-manager
  hardware-configuration.nix  # nixos-generate-config 生成,勿手改
home/                         # home-manager(用户 tuf3i)
  tuf3i.nix                   # 入口
  shell.nix                   # zsh / direnv / fzf
  tools.nix                   # git(delta) / neovim / 命令行工具
  apps.nix                    # ghostty
modules/
  core/                       # 系统基础:boot、nix 与 nh、zsh、系统工具、代理(未启用)
  desktop/                    # niri + DMS 桌面、字体
  application/                # 浏览器、输入法、claude、zcode 等
  service/                    # mihomo(占位)
```

## 常用命令

```bash
nh os switch          # 应用配置( nh.flake 已指向本仓库 )
sudo nixos-rebuild test --flake .#zenbook   # 测试性应用,重启后失效
nix search nixpkgs 包名    # 搜包
```

## 维护说明

- 系统层(NixOS modules)管包和服务,保证 root 也能用;`$HOME` 下的 dotfiles
  (`.zshrc`、`.gitconfig`、ghostty 配置)由 home-manager 生成,**不要手工编辑**。
- Nix 每周自动 GC,清理 14 天前的旧 generation;手动立即清理:
  `sudo nix-collect-garbage -d`。
- GRUB 只保留最近 10 个 generation。

## 首次启用 home-manager

若 `~/.zshrc`、`~/.gitconfig`、`~/.config/ghostty/` 中有手工维护的旧文件,
首次 switch 会因文件冲突激活失败,先备份移走再 switch。
