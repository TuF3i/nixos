# Navicat Premium Lite 中文社区版(v18)打包
#
# 参考 nixpkgs navicat-premium/package.nix 的 AppImage 提取打包方式:
#   https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/by-name/na/navicat-premium/package.nix
# 与 premium 版差异:
#   - 源为官方中文社区版(免费,无需 license 弹窗处理)
#   - v18 的 AppImage 在 squashfs 镜像前附加了一段 ELF 数据,
#     appimageTools.extract 以 AppRun 解析偏移时不受影响,可直接使用
#   - 未发现 v17 需要的 libselinux/glib 替换与 libpq crypt 重链接问题
#     (v18 lite 的 pq-g 自带 libcrypt.so.1),如构建或启动报缺库再对照补
{
  lib,
  stdenv,
  fetchurl,
  appimageTools,
  autoPatchelfHook,
  qt6,
  cjson,
  curl,
  e2fsprogs,
  expat,
  fontconfig,
  freetype,
  glib,
  glibc,
  harfbuzz,
  libGL,
  libx11,
  libgpg-error,
  libselinux,
  libxcb,
  libxcrypt,
  libxkbcommon,
  p11-kit,
  pango,
  copyDesktopItems,
  makeDesktopItem,
}:

let
  version = "18.0.1";
  pname = "navicat-premium-lite-cs";
  src = fetchurl {
    url = "https://dn.navicat.com.cn/download/navicat18-premium-lite-cs-x86_64.AppImage";
    hash = "sha256-srpzTWRhI0LeX11Jz7CHPD2/opWEn1EjRLq801LOm5I=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  inherit pname version;

  src = appimageTools.extract {
    inherit pname version;
    inherit src;
  };

  nativeBuildInputs = [
    autoPatchelfHook
    qt6.wrapQtAppsHook
    copyDesktopItems
  ];

  buildInputs = [
    cjson
    curl
    e2fsprogs
    expat
    fontconfig
    freetype
    glib
    glibc
    harfbuzz
    libGL
    libx11
    libgpg-error
    libselinux
    libxcb
    libxcrypt
    libxkbcommon
    p11-kit
    pango
    qt6.qtbase
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "navicat-premium-lite-cs";
      exec = "navicat";
      icon = "navicat-premium-lite-cs";
      desktopName = "Navicat Premium Lite";
      genericName = "数据库开发工具";
      categories = [ "Development" "Database" ];
      keywords = [ "database" "sql" "navicat" ];
    })
  ];

  installPhase = ''
    runHook preInstall

    cp -r --no-preserve=mode $src/usr $out
    chmod +x $out/bin/navicat
    mkdir -p $out/usr
    ln -s $out/lib $out/usr/lib

    # 桌面图标
    install -Dm644 $src/icon.png $out/share/icons/hicolor/256x256/apps/navicat-premium-lite-cs.png

    runHook postInstall
  '';

  dontWrapQtApps = true;

  preFixup = ''
    wrapQtApp $out/bin/navicat \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          e2fsprogs
          expat
          fontconfig
          freetype
          glib
          glibc
          harfbuzz
          libGL
          libx11
          libgpg-error
          libselinux
          libxcb
          libxkbcommon
          p11-kit
          pango
        ]
      }:$out/lib \
      --set QT_PLUGIN_PATH $out/plugins \
      --set QT_QPA_PLATFORM xcb \
      --set QT_STYLE_OVERRIDE Fusion \
      --chdir $out
  '';

  meta = {
    homepage = "https://www.navicat.com.cn/products/navicat-premium-lite";
    description = "Navicat Premium Lite 中文社区版,轻量级数据库开发工具";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = [ ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "navicat";
  };
})
