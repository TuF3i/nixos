# 嘉立创EDA专业版 2.2.45.5 打包(Electron zip → steam-run FHS 运行时)
#
# 锁老版本原因:4.1.60 新版在 NixOS 2026 栈上 3D/2D 渲染异常(Canvas2D 卡顿、
# WebGPU 黑屏;Debian 同版本无此现象),2.2.45.5 无此问题。
#
# 运行方式:steam-run 提供完整 FHS(Mesa 驱动/glibc/字体/dbus 全套,
# Steam 游戏生态验证),WebGL 硬件加速可用,中文渲染正常。
#
# 构建注意:src 为绝对路径,构建必须加 --impure:
#   nh os switch -- --impure
# 更新版本:下载新 zip 放 Downloads/,改 src 路径与 version 即可。
{
  lib,
  pkgs,
  stdenv,
  autoPatchelfHook,
  makeWrapper,
  makeDesktopItem,
  symlinkJoin,
  libarchive,
  steam-run,
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
}:

let
  pname = "lceda-pro";
  version = "2.2.45.5";

  # 第一层:解包 Electron 树并修补,入口带 --no-sandbox --gtk-version=3
  app = stdenv.mkDerivation (finalAttrs: {
    inherit pname version;

    src = /home/tuf3i/Downloads/lceda-pro-linux-x64-${version}.zip;

    nativeBuildInputs = [
      # bsdtar 而非 unzip:zip 内含中文文件名的 EULA pdf,unzip 会报
      # 文件名不匹配错误
      libarchive
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
      "libc.musl-x86_64.so.1"
    ];

    dontConfigure = true;
    dontBuild = true;
    dontStrip = true;

    unpackPhase = ''
      # 沙箱无中文 locale,bsdtar 需 C.UTF-8 才能处理 zip 内的中文文件名
      export LC_ALL=C.UTF-8
      bsdtar -x -f $src
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/lib/lceda-pro
      cp -r lceda-pro/. $out/lib/lceda-pro/
      chmod +x $out/lib/lceda-pro/lceda-pro

      makeWrapper $out/lib/lceda-pro/lceda-pro $out/bin/.lceda-pro-real \
        --add-flags "--no-sandbox --gtk-version=3" \
        --set APPDIR "$out/lib/lceda-pro"

      install -Dm644 lceda-pro/icon/icon_128x128.png \
        $out/share/icons/hicolor/128x128/apps/lceda-pro.png

      runHook postInstall
    '';

    meta.sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    meta.mainProgram = "lceda-pro";
  });

  desktopItem = makeDesktopItem {
    name = "lceda-pro";
    exec = "lceda-pro %f";
    icon = "lceda-pro";
    desktopName = "嘉立创EDA(专业版)";
    genericName = "在线电路设计软件";
    categories = [ "Development" "Electronics" ];
    keywords = [ "PCB" "LCEDA" "EDA" ];
  };
in
# 第二层:steam-run FHS 运行时包装,启动前清理陈旧引擎 socket
symlinkJoin {
  inherit pname version;
  paths = [ app ];

  postBuild = ''
    # symlinkJoin 不会执行 copyDesktopItems hook,桌面条目手动装
    mkdir -p $out/share/applications
    cp ${desktopItem}/share/applications/*.desktop $out/share/applications/

    bin="$out/bin/lceda-pro"
    cat > "$bin" <<'EOF'
    #!/run/current-system/sw/bin/bash
    rm -f /tmp/JLCEDAPro*.sock 2>/dev/null || true
    exec steam-run "$(dirname "$(readlink -f "$0")")/.lceda-pro-real" "$@"
    EOF
    chmod +x "$bin"
  '';

  meta = {
    homepage = "https://lceda.cn";
    description = "嘉立创EDA(专业版),免费、强大、易用的在线电路设计软件";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = [ ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "lceda-pro";
  };
}
