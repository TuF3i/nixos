# Apifox API 开发平台打包(linux zip → 内层 Electron AppImage → FHS 沙箱)
#
# 沿用 yakit/ARDM 的成熟模式:
#   - zip 内含 AppImage:构建期解 zip 再 appimageTools.extract
#   - 字体进 targetPkgs + 自带 fonts.conf(中文不依赖宿主配置)
#   - --no-sandbox(上游 desktop 自带)+ --disable-gpu
#     (规避 XWayland 下 GPU 进程失败自退/渲染损坏一类问题)
#   - --use-fake-device-for-media-stream(规避视频采集线程 CHECK 崩溃一类问题)
#   - 旧式托盘兼容库(libappindicator/libgconf)依赖缺失按惯例跳过
{
  lib,
  pkgs,
  stdenv,
  fetchurl,
  unzip,
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
  pname = "apifox";
  version = "latest-2026-09";

  zip = fetchurl {
    url = "https://file-assets.apifox.com/download/Apifox-linux-latest.zip";
    hash = "sha256-g6cp4NA9KxoTdE8aOkvv/DhivaZnx8MZODJf2/ZrowY=";
  };

  # 从 zip 取出内层 AppImage 作为独立 store 产物
  appimage = stdenv.mkDerivation {
    name = "Apifox.AppImage";
    src = zip;
    nativeBuildInputs = [ unzip ];
    dontUnpack = true;
    installPhase = ''
      unzip -q "$src" Apifox.AppImage
      cp Apifox.AppImage $out
    '';
    meta.sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };

  fontsConf = pkgs.writeText "apifox-fonts.conf" ''
    <?xml version="1.0"?>
    <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
    <fontconfig>
      <dir>/usr/share/fonts</dir>
      <dir prefix="xdg">fonts</dir>
      <cachedir>/tmp/fontconfig-cache</cachedir>

      <!-- monospace 落在 ASCII 等宽字体上(同 yakit 的 xterm 修复);
           sans/serif 钉住 CJK -->
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

  # 第一层:AppImage 解包,入口加渲染/沙箱参数
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

    autoPatchelfIgnoreMissingDeps = [
      "libdbus-glib-1.so.2"
      "libgtk-x11-2.0.so.0"
      "libdbusmenu-glib.so.4"
      "libdbusmenu-gtk.so.4"
      "libdbusmenu-gtk3.so.4"
      # Apifox 自带的 IBM DB2 驱动(不连 DB2 用不到)
      "libdb2.so.1"
      # musl 静态辅助库
      "libc.musl-x86_64.so.1"
    ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/lib/apifox $out/bin
      cp -r . $out/lib/apifox
      rm -f $out/lib/apifox/AppRun $out/lib/apifox/*.desktop

      makeWrapper $out/lib/apifox/apifox $out/bin/apifox \
        --add-flags "--no-sandbox --disable-gpu --use-fake-device-for-media-stream" \
        --set APPDIR "$out/lib/apifox"

      install -Dm644 $src/apifox.png \
        $out/share/icons/hicolor/512x512/apps/apifox.png

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
    runScript = pkgs.writeShellScript "apifox-run" ''
      export FONTCONFIG_FILE="${fontsConf}"
      exec "${app}/bin/apifox" "$@"
    '';
  };

  desktopItem = makeDesktopItem {
    name = "apifox";
    exec = "apifox %U";
    icon = "apifox";
    desktopName = "Apifox";
    genericName = "API 开发平台";
    categories = [ "Development" ];
    keywords = [ "api" "apifox" "postman" ];
  };
in
symlinkJoin {
  inherit pname version;
  paths = [ fhs ];

  postBuild = ''
    # symlinkJoin 没有 installPhase,桌面条目与图标手动安装
    mkdir -p $out/share/applications
    cp ${desktopItem}/share/applications/*.desktop $out/share/applications/
    install -Dm644 ${app}/share/icons/hicolor/512x512/apps/apifox.png \
      $out/share/icons/hicolor/512x512/apps/apifox.png
  '';

  meta = {
    homepage = "https://apifox.com";
    description = "Apifox,API 文档、API 调试、API Mock、API 自动化测试一体化协作平台";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = [ ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "apifox";
  };
}
