# nixos

TuF3i 的 NixOS 配置。基于 NixOS unstable + home-manager,多主机结构。

## 结构

```
flake.nix                     # 入口:inputs 与 nixosConfigurations
target/                       # 各主机配置(文件夹名 = 主机名)
  zenbook/
    configuration.nix         # 入口:imports + 主机身份(时区/网络/用户/HM)
    system/                   # 本机全局配置
      hardware-configuration.nix  # nixos-generate-config 生成,勿手改
      boot.nix                     # GRUB
      nixos.nix                    # nix 设置/nh/GC/电源/显卡/温控
      proxy.nix                    # nix-daemon 临时代理(默认关闭)
    home/                     # home-manager(用户 tuf3i)
      default.nix                 # 入口
      shell.nix                   # zsh / direnv / fzf / 别名
      tools.nix                   # git 身份+签名 / delta
      apps.nix                    # ghostty / 光标主题
      gpg-ssh.nix                 # GPG 签名 + SSH
modules/                      # 共享模块库,供 target 按需导入
  cli/                        # CLI 工具,每个工具一个 <名称>.nix 单文件
  gui/                        # GUI 应用:browser / libreoffice / fcitx5
  desktop/                    # 桌面环境:niri / dms / greeter
  service/                    # 服务:clash-verge / zerotier
```

## 加一台新主机

1. 复制 `target/zenbook/` 为 `target/<新主机名>/`
2. 替换 `system/hardware-configuration.nix`(nixos-generate-config 生成)
3. 按需增删 imports(cli 工具单文件按需挑)
4. `flake.nix` 的 `nixosConfigurations` 加一项

## 常用命令

```bash
nh os switch          # 应用配置(nh.flake 已指向本仓库)
sudo nixos-rebuild test --flake .#zenbook   # 测试性应用
nix search nixpkgs 包名    # 搜包
```

## 维护说明

- 系统层管包和服务;`$HOME` 下的 dotfiles 由 home-manager 生成,不要手工编辑
  (`~/.config/nvim` 例外,由 AstroNvim 模板手动管理)
- Nix 每周自动 GC,清理 14 天前的旧 generation;GRUB 保留最近 10 个
- 首次启用 HM:若 `~/.zshrc` 等有手工旧文件,冲突会自动备份为 `*.backup`
