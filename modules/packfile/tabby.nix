# Tabby 终端打包(Electron AppImage → FHS 沙箱)
#
# 沿用 yakit/apifox 的成熟模式:
#   - 字体进 targetPkgs + 自带 fonts.conf:Tabby 内核是 xterm.js,
#     monospace 别名必须落在 ASCII 等宽字体上(同 yakit 日志字距修复)
#   - --no-sandbox(nix store 无法 setuid chrome-sandbox)
#   - --disable-gpu(规避 XWayland GPU 渲染损坏一类问题,软件渲染足够)
#   - APPDIR 指向解包目录
{
  lib,
  pkgs,
  stdenv,
  fetchurl,
  appimageTools,
  autoPatchelfHook,
  makeWrapper,
  makeDesktopItem,
  buildFHSEnv,
  symlinkJoin,
  alsa-lib,
  atk,
  at-spi2-atk,
  at-spi2-core,
  cairo,
  cups,
  dbus,
  expat,
  fontconfig,
  gdk-pixbuf,
  glib,
  gtk3,
  libdrm,
  libgbm,
  libx11,
  libxcb,
  libXcomposite,
  libXdamage,
  libXext,
  libXfixes,
  libxkbcommon,
  libXrandr,
  libxshmfence,
  libudev0-shim,
  libsecret,
  nss,
  nspr,
  pango,
  noto-fonts,
  noto-fonts-cjk-sans,
  noto-fonts-color-emoji,
  dejavu_fonts,
}:

let
  pname = "tabby";
  version = "1.0.237";
  appimage = fetchurl {
    url = "https://github.com/Eugeny/tabby/releases/download/v${version}/tabby-${version}-linux-x64.AppImage";
    hash = "sha256-3l3BJGatSbesX7ST5/u4pN8NLCMmWZaoxV9JA2fKa+Q=";
  };

  fontsConf = pkgs.writeText "tabby-fonts.conf" ''
    <?xml version="1.0"?>
    <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
    <fontconfig>
      <!-- 直接指向字体包 store 路径:buildEnv 合并出的 /usr/share/fonts
           里符号链接子目录会被 fontconfig 跳过,导致字体列表残缺 -->
      <dir>${pkgs.nerd-fonts.fira-code}/share/fonts</dir>
      <dir>${pkgs.noto-fonts-cjk-sans}/share/fonts</dir>
      <dir>${pkgs.noto-fonts-color-emoji}/share/fonts</dir>
      <dir>${pkgs.noto-fonts}/share/fonts</dir>
      <dir>${pkgs.dejavu_fonts}/share/fonts</dir>
      <dir prefix="xdg">fonts</dir>
      <cachedir>/tmp/fontconfig-cache</cachedir>

      <!-- xterm.js 内核:monospace 首选 FiraCode Nerd Font(与系统终端一致) -->
      <alias>
        <family>monospace</family>
        <prefer>
          <family>FiraCode Nerd Font</family>
          <family>DejaVu Sans Mono</family>
          <family>Noto Sans Mono CJK SC</family>
        </prefer>
      </alias>
      <alias>
        <family>sans-serif</family>
        <prefer>
          <family>Noto Sans CJK SC</family>
          <family>DejaVu Sans</family>
        </prefer>
      </alias>
      <alias>
        <family>serif</family>
        <prefer>
          <family>Noto Serif CJK SC</family>
          <family>DejaVu Serif</family>
        </prefer>
      </alias>
    </fontconfig>
  '';

  # 第一层:AppImage 解包,入口统一加沙箱参数
  app = stdenv.mkDerivation {
    inherit pname version;
    src = appimageTools.extract {
      inherit pname version;
      src = appimage;
    };

    nativeBuildInputs = [
      autoPatchelfHook
      makeWrapper
    ];

    buildInputs = [
      alsa-lib
      atk
      at-spi2-atk
      at-spi2-core
      cairo
      cups
      dbus
      expat
      fontconfig
      gdk-pixbuf
      glib
      gtk3
      libdrm
      libgbm
      libx11
      libxcb
      libXcomposite
      libXdamage
      libXext
      libXfixes
      libxkbcommon
      libXrandr
      libxshmfence
      libudev0-shim
      libsecret
      nss
      nspr
      pango
    ];

    autoPatchelfIgnoreMissingDeps = [
      "libdbus-glib-1.so.2"
      "libgtk-x11-2.0.so.0"
      "libdbusmenu-glib.so.4"
      "libdbusmenu-gtk.so.4"
      "libdbusmenu-gtk3.so.4"
      # serialport 的 musl 预编译变体,glibc 环境不用
      "libc.musl-x86_64.so.1"
    ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/lib/tabby $out/bin
      cp -r . $out/lib/tabby
      rm -f $out/lib/tabby/AppRun $out/lib/tabby/*.desktop

      makeWrapper $out/lib/tabby/tabby $out/bin/tabby \
        --add-flags "--no-sandbox --disable-gpu" \
        --set APPDIR "$out/lib/tabby" \
        --set FONTCONFIG_FILE "${fontsConf}"

      install -Dm644 $src/tabby.png \
        $out/share/icons/hicolor/512x512/apps/tabby.png

      runHook postInstall
    '';

    dontStrip = true;
    meta.sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };

  # 第二层:FHS 沙箱:补齐 Chromium 期望的 /usr 布局;字体自洽
  fhs = buildFHSEnv {
    inherit pname version;
    targetPkgs = pkgs': with pkgs'; [
      app
      fontconfig
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      dejavu_fonts
      # 终端等宽字体(FiraCode Nerd Font,与系统 ghostty 一致)
      nerd-fonts.fira-code

      alsa-lib
      atk
      at-spi2-atk
      at-spi2-core
      cairo
      cups
      dbus
      expat
      gdk-pixbuf
      glib
      gtk3
      libdrm
      libgbm
      libx11
      libxcb
      libXcomposite
      libXdamage
      libXext
      libXfixes
      libxkbcommon
      libXrandr
      libxshmfence
      libudev0-shim
      libsecret
      nss
      nspr
      pango
    ];
    runScript = pkgs.writeShellScript "tabby-run" ''
      export FONTCONFIG_FILE="${fontsConf}"
      exec "${app}/bin/tabby" "$@"
    '';
  };

  desktopItem = makeDesktopItem {
    name = "tabby";
    exec = "tabby %U";
    icon = "tabby";
    desktopName = "Tabby Terminal";
    genericName = "终端模拟器";
    categories = [ "System" "Utility" "TerminalEmulator" ];
    keywords = [ "terminal" "ssh" "serial" ];
  };
in
symlinkJoin {
  inherit pname version;
  paths = [ fhs ];

  postBuild = ''
    # symlinkJoin 没有 installPhase,桌面条目与图标手动安装
    mkdir -p $out/share/applications
    cp ${desktopItem}/share/applications/*.desktop $out/share/applications/
    install -Dm644 ${app}/share/icons/hicolor/512x512/apps/tabby.png \
      $out/share/icons/hicolor/512x512/apps/tabby.png
  '';

  meta = {
    homepage = "https://github.com/Eugeny/tabby";
    description = "Tabby,现代化终端模拟器(SSH/串口/Telnet)";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "tabby";
  };
}
