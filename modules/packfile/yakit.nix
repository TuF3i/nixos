# Yakit 网络安全测试平台打包(Electron AppImage → FHS 沙箱)
#
# 沿用 ARDM 踩坑后的成熟模式(见 another-redis-desktop-manager.nix 历史记录):
#   - appimageTools.extract + autoPatchelf(其 RUNPATH 指向 nix 库,宿主可直接跑)
#   - buildFHSEnv + 字体进 targetPkgs + 自带 fonts.conf(中文不依赖宿主配置)
#   - --no-sandbox(nix store 无法 setuid chrome-sandbox)
#   - --use-fake-device-for-media-stream(规避 ARDM 同款视频采集线程 CHECK 崩溃)
#   - APPDIR 指向解包目录,保证应用能找到自带的 bins/(yak 引擎数据);
#     引擎本体首次运行时联网下载,为通用 Linux 二进制,由 nix-ld 兜底运行
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
  nss,
  nspr,
  pango,
  noto-fonts,
  noto-fonts-cjk-sans,
  noto-fonts-color-emoji,
  dejavu_fonts,
}:

let
  pname = "yakit";
  version = "1.4.8";
  appimage = fetchurl {
    url = "https://oss-qn.yaklang.com/yak/1.4.8-0919/Yakit-1.4.8-0919-linux-amd64.AppImage";
    hash = "sha256-HWVIWsJTQ8VJ6xI+Vul2xqnVmbmT9HCrgisOCFOqhBE=";
  };

  fontsConf = pkgs.writeText "yakit-fonts.conf" ''
    <?xml version="1.0"?>
    <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
    <fontconfig>
      <dir>/usr/share/fonts</dir>
      <dir prefix="xdg">fonts</dir>
      <cachedir>/tmp/fontconfig-cache</cachedir>

      <!-- monospace 必须落在 ASCII 等宽字体上,否则 xterm.js 日志面板
           会按 CJK 全宽单元格排版 ASCII,字距散架 -->
      <alias>
        <family>monospace</family>
        <prefer>
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

  # 第一层:AppImage 解包,入口统一加渲染/沙箱参数并注入 APPDIR
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
      nss
      nspr
      pango
    ];

    # Electron 自带的旧式托盘兼容库若有 GTK2 依赖,autoPatchelf 跳过
    autoPatchelfIgnoreMissingDeps = [
      "libdbus-glib-1.so.2"
      "libgtk-x11-2.0.so.0"
      "libdbusmenu-glib.so.4"
      "libdbusmenu-gtk.so.4"
      "libdbusmenu-gtk3.so.4"
    ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/lib/yakit $out/bin
      cp -r . $out/lib/yakit
      rm -f $out/lib/yakit/AppRun $out/lib/yakit/*.desktop

      makeWrapper $out/lib/yakit/yakit $out/bin/yakit \
        --add-flags "--no-sandbox --disable-gpu --use-fake-device-for-media-stream" \
        --set APPDIR "$out/lib/yakit" \
        --set FONTCONFIG_FILE "${fontsConf}"

      install -Dm644 $src/yakit.png \
        $out/share/icons/hicolor/512x512/apps/yakit.png

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
      nss
      nspr
      pango
    ];
    runScript = pkgs.writeShellScript "yakit-run" ''
      export FONTCONFIG_FILE="${fontsConf}"
      exec "${app}/bin/yakit" "$@"
    '';
  };

  desktopItem = makeDesktopItem {
    name = "yakit";
    exec = "yakit %U";
    icon = "yakit";
    desktopName = "Yakit";
    genericName = "网络安全测试平台";
    categories = [ "Development" "Security" "Network" ];
    keywords = [ "yak" "security" "fuzz" "hacker" ];
  };
in
symlinkJoin {
  inherit pname version;
  paths = [ fhs ];

  postBuild = ''
    # symlinkJoin 没有 installPhase,桌面条目与图标手动安装
    mkdir -p $out/share/applications
    cp ${desktopItem}/share/applications/*.desktop $out/share/applications/
    install -Dm644 ${app}/share/icons/hicolor/512x512/apps/yakit.png \
      $out/share/icons/hicolor/512x512/apps/yakit.png
  '';

  meta = {
    homepage = "https://www.yaklang.io/products/yakit";
    description = "Yakit,基于 yaklang 的网络安全测试平台";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfreeRedistributable;
    maintainers = [ ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "yakit";
  };
}
