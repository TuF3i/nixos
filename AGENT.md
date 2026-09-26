# AGENT.md — 本仓库运维踩坑记录

给 AI 助手和维护者的备忘:本仓库配置演进过程中实际踩过的坑与定论。
改配置前先查这里,避免重复试错。

## 构建与系统管理

### 必须用 --impure 构建
packfile 里部分包(嘉立创EDA)的 src 引用了仓库外的绝对路径
(/home/tuf3i/Downloads/*.zip,官方 API 需登录签名,无法 fetchurl),
纯求值模式会报 `access to absolute path ... is forbidden`。
```bash
nh os switch -- --impure
sudo nixos-rebuild switch --flake /home/tuf3i/nixos#zenbook --impure
```

### nix build 的错误输出会骗人
- 失败时 `--print-out-paths` 也会打印 Output paths(未构建成功的),别当产物;
  必须检查 exit code,或把输出重定向到文件后 grep `error:`(行首可能带缩进,
  用 `grep -E "^error|error:"` 而非 `grep "^error"`)
- 同名 store 路径重复出现时,先 `ls` 确认路径是否真实存在再验证内容

### nixpkgs unstable(2026.09 快照)包名/属性变更记录
| 旧名/直觉名 | 现名 | 备注 |
|---|---|---|
| python3Full | 已移除 | 功能并入 python3 |
| webkitgtk_4_0 | 已移除 | 需移植 webkitgtk_4_1(libsoup2→3) |
| openssl_1_1 | 已移除 | 从 Ubuntu 22.04 源取 libssl1.1 deb |
| programs.zsh.initExtra | initContent | |
| programs.ssh.addKeysToAgent | programs.ssh.settings."*".AddKeysToAgent(settings 是 DAG 块结构) | |
| services.gpg-agent.pinentryPackage | pinentry.package | |
| programs.git.extraConfig / signing 旧位 | programs.git.settings.* | |
| xorg.xwininfo / xorg.xrandr | xwininfo / xrandr(顶层) | xorg scope 弃用 |
| nodePackages.* | 已移除 | 包迁至顶层(如 gitmoji-cli) |
| pkgs.helm | kubernetes-helm | helm 是同名合成器! |
| fonts.packages 里 noto CJK | noto-fonts-cjk-sans | 没有 -serif 后缀写法 |

## GUI 应用打包(packfile/ 模式)

成熟套路见 packfile/yakit.nix、apifox.nix(解包层 + buildFHSEnv 层):
1. appimageTools.extract(或 zip 解包/dpkg-deb -x)→ autoPatchelfHook
2. buildFHSEnv 外层沙箱,字体(fontconfig + noto CJK)进 targetPkgs
3. 入口统一 --no-sandbox(--disable-gpu 视应用,见下)

### 踩坑定论
- **buildFHSEnv 的 runScript 是摆设**:里面写的东西不会执行,
  环境变量必须放应用的 makeWrapper 里
- **fonts.conf 的 <dir> 不要扫 /usr/share/fonts**:buildEnv 合并树里
  符号链接子目录会被 fontconfig 跳过(字体列表只剩 3 个),
  直接指向各字体包的 store 路径,并显式写 monospace 别名
  (monospace 落到 CJK 等宽字体时 xterm.js ASCII 字距会散架)
- **zip 内含中文文件名**:用 libarchive 的 bsdtar + `export LC_ALL=C.UTF-8`
  (unzip 报文件名不匹配;无中文 locale 时 bsdtar 也会挂)
- **视频采集线程崩溃**(SIGTRAP,栈含 VideoCaptureThr):加
  `--use-fake-device-for-media-stream`(ARDM 实证)
- **GPU 渲染损坏**(全界面乱码/绿色窗口,wemeet 同病):加 `--disable-gpu`
  可绕过;但 EDA 类 WebGL 应用禁 GPU 会卡顿,需改为修 GPU 链路
  (FHS 内补 mesa/libglvnd/libgbm/dri 驱动,逐个 dlopen 报错定位)
- **应用单实例 + 常驻后台**:窗口"消失"≠退出,从启动器/命令行再开一次
  会唤回(apifox/tabby 实证);pkill 时注意 pkill -f 的模式会匹配到
  自己所在的 shell,用 pkill -x 或精确路径
- **老 Java AWT(X11)输入问题**(iDRAC6 KVM):fcitx5 拦截键盘 →
  `XMODIFIERS=@im=none`;XWayland 分数缩放(1.1)致鼠标偏移 →
  Xephyr 嵌套屏内运行(xwininfo 轮询窗口几何 + xrandr 同步 Xephyr 大小)
- **credential helper 多词值必须 ! 开头**:`helper = "tea login helper"`
  会让 git 执行不存在的 git-credential-tea;正确写法 `!tea login helper`
- **官方下载 API 需登录签名**(lceda/yakit 类):src 用绝对路径引用
  ~/Downloads 下的 zip + --impure 构建,或过期签名 URL + builtins.fetchurl

### 已知应用兼容性定论
- **嘉立创EDA 4.1.60**:渲染异常(Canvas2D 卡顿/WebGPU 黑屏),锁 2.2.45.5;
  steam-run 运行时 + GPU 链路(mesa/libglvnd/libgbm/dri)可恢复流畅
- **ARDM(Electron 22)**:2026 栈上必崩,放弃(FHS/裸跑/字体修复全试过)
- **wemeet**:绿色窗口为渲染损坏;nixpkgs 包自带 wayland-screenshare hook
- **Etcher**:输入/文件选择在沙箱下异常,换 Impression 原生 GTK

## 系统服务要点
- **gnome-keyring**:Electron 应用凭据存储依赖它;PAM 解锁已配
  (greetd/dms-greeter/login);Electron 在非 GNOME 桌面下 safeStorage
  默认走 KWallet,需 `--password-store=gnome`(Compass 有严格参数校验,
  须同时加 --ignore-additional-command-line-flags)
- **Compass 凭据警告未修**:gnome-keyring 正常、secret-tool 读写正常,
  Compass 自身仍报 cannot access credential storage,放弃深挖
- **flathub 上没有** AnotherRedisDesktopManager;不要凭记忆断言包存在,
  一律先 nix search / nix eval 验证属性名

## 铁律
1. 任何包/选项名先 `nix eval`/`nix search` 验证再用,不凭记忆
2. HM 生成的 ~/.config/git/config 等只读文件,工具(gh/tea)运行时
   无法写入,相关配置一律声明在 HM 里
3. GUI 应用"打不开"先分清:进程死了(coredumpctl)、窗口没画出来
   (渲染问题)、还是单实例进了后台(再开一次唤回)
4. 用户只要求写配置时,不主动执行命令(构建验证类除外)
