  # 嘉立创EDA专业版打包(Electron zip → FHS 沙箱)
#
# 下载渠道:官方 API 需登录签名(lceda.cn/api/files/download-url?uri=...),
# 返回带 auth_key 的时效 URL。fetchurl 直接使用该签名 URL 并锁定内容哈希;
# auth_key 过期后构建报 403/404,重新调 API 取新 URL 替换下面 url 中的
# auth_key 部分即可(哈希不变)。
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
  libarchive,
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
  pname = "lceda-pro";
  version = "4.1.60";

  # 手动下载的官方 zip(官方 API 需登录才能取得签名下载地址)。
  # 本地路径引用需要构建时关闭纯求值:--impure
  # (nh os switch -- --impure 或 sudo nixos-rebuild switch --flake ... --impure)
  # 更新版本:下载新 zip 到 Downloads/,改下面的路径与 version
  src = /home/tuf3i/Downloads/lceda-pro-linux-x64-${version}.zip;

  fontsConf = pkgs.writeText "lceda-fonts.conf" ''
    <?xml version="1.0"?>
    <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
    <fontconfig>
      <dir>/usr/share/fonts</dir>
      <dir prefix="xdg">fonts</dir>
      <cachedir>/tmp/fontconfig-cache</cachedir>

      <!-- monospace 首选 ASCII 等宽字体 -->
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

  # 第一层:解包 Electron 树,入口加参数
  app = stdenv.mkDerivation {
    inherit pname version src;

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

      mkdir -p $out/lib/lceda-pro $out/bin
      cp -r lceda-pro/. $out/lib/lceda-pro/
      chmod +x $out/lib/lceda-pro/lceda-pro

      makeWrapper $out/lib/lceda-pro/lceda-pro $out/bin/lceda-pro \
        --add-flags "--no-sandbox --disable-gpu --gtk-version=3" \
        --set APPDIR "$out/lib/lceda-pro" \
        --set FONTCONFIG_FILE "${fontsConf}"

      runHook postInstall
    '';

    meta.sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };

  # 第二层:FHS 沙箱
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
    runScript = pkgs.writeShellScript "lceda-run" ''
      exec "${app}/bin/lceda-pro" "$@"
    '';
  };

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
symlinkJoin {
  inherit pname version;
  paths = [ fhs ];

  postBuild = ''
    # symlinkJoin 没有 installPhase,桌面条目与图标手动安装
    mkdir -p $out/share/applications $out/share/icons/hicolor/128x128/apps
    cp ${desktopItem}/share/applications/*.desktop $out/share/applications/
    install -Dm644 ${app}/lib/lceda-pro/icon/icon_128x128.png \
      $out/share/icons/hicolor/128x128/apps/lceda-pro.png
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
