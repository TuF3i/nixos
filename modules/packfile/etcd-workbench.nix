# Etcd Workbench 打包(Tauri 应用:Rust + WebKitGTK,来自 .deb)
#
# Tauri 与 Electron 不同:单文件二进制 + WebKitGTK 系统库,无需 FHS 沙箱;
# 宿主 fontconfig 直接可用(中文渲染正常)。依赖要点:
#   - webkitgtk_4_1:上游按 webkitgtk_4_0(ubuntu 22.04)构建,但 4_0 已从
#     nixpkgs 移除;二进制仅直接使用 2 个 soup 符号(soup_message_headers_get_type/
#     append,libsoup3 同名同签名),故 patchelf replace-needed 到 4.1 系列安全
#   - openssl_1_1(TLS 连 etcd 用,符号版本 OPENSSL_1_1_0/1_1_1,openssl3 不兼容)
# WEBKIT_DISABLE_DMABUF_RENDERER=1:NixOS 上 WebKitGTK 已知的
# dmabuf 渲染 bug(白屏/花屏)规避
{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  patchelf,
  autoPatchelfHook,
  makeWrapper,
  webkitgtk_4_1,
  gtk3,
  glib,
  cairo,
  gdk-pixbuf,
  pango,
  libxkbcommon,
  libayatana-appindicator,
}:

let
  # openssl 1.1:上游用 Ubuntu 22.04 的 libssl1.1 构建(TLS 连 etcd),
  # 符号版本 OPENSSL_1_1_0/1_1_1,openssl3 不兼容,nixpkgs 的 openssl_1_1 已移除
  libssl11 = stdenv.mkDerivation {
    pname = "libssl1.1";
    version = "1.1.1f-1ubuntu2.24";
    src = fetchurl {
      url = "https://security.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2.24_amd64.deb";
      hash = "sha256-fPOdcKY5AX0d18jTbaoiWAY2CGiORJ/d9A/91G+ZKng=";
    };
    nativeBuildInputs = [ dpkg ];
    dontConfigure = true;
    dontBuild = true;
    dontStrip = true;
    unpackPhase = "dpkg-deb -x $src .";
    installPhase = ''
      mkdir -p $out/lib
      cp -r usr/lib/x86_64-linux-gnu/. $out/lib/
    '';
    meta.sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
in

stdenv.mkDerivation (finalAttrs: {
  pname = "etcd-workbench";
  version = "1.2.7";

  src = fetchurl {
    url = "https://github.com/tzfun/etcd-workbench/releases/download/App-${finalAttrs.version}/etcd-workbench-${finalAttrs.version}-linux-x86_64.deb";
    hash = "sha256-Vuzp1qE2RoMHGXDOxnDAU9bz29A28ubbkUe5+jl0Ky0=";
  };

  nativeBuildInputs = [
    dpkg
    patchelf
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    webkitgtk_4_1
    gtk3
    glib
    cairo
    gdk-pixbuf
    pango
    libssl11
    libxkbcommon
    libayatana-appindicator
  ];

  dontConfigure = true;
  dontBuild = true;
  dontStrip = true;

  unpackPhase = ''
    dpkg-deb -x $src .

    # webkitgtk 4.0 → 4.1 平移(SONAME 与 soup 版本替换,见文件头注释)
    patchelf --replace-needed libwebkit2gtk-4.0.so.37 libwebkit2gtk-4.1.so.0 usr/bin/etcd-workbench
    patchelf --replace-needed libjavascriptcoregtk-4.0.so.18 libjavascriptcoregtk-4.1.so.0 usr/bin/etcd-workbench
    patchelf --replace-needed libsoup-2.4.so.1 libsoup-3.0.so.0 usr/bin/etcd-workbench
  '';

  installPhase = ''
    runHook preInstall

    cp -r usr $out
    chmod +x $out/bin/etcd-workbench

    runHook postInstall
  '';

  preFixup = ''
    # WebKitGTK 渲染 bug 规避(NixOS Tauri 常见):
    #   - 强制 GDK_BACKEND=x11 走 XWayland:原生 Wayland 后端黑屏
    #   - DMABUF_RENDERER / 加速合成一并禁用(软件渲染)
    # 真实二进制挪到 libexec 保持 basename 不变,避免 WM_CLASS/App ID 变成 .real
    mkdir -p $out/libexec
    mv $out/bin/etcd-workbench $out/libexec/etcd-workbench
    makeWrapper $out/libexec/etcd-workbench $out/bin/etcd-workbench \
      --set GDK_BACKEND x11 \
      --set WEBKIT_DISABLE_DMABUF_RENDERER 1 \
      --set WEBKIT_DISABLE_COMPOSITING_MODE 1
  '';

  meta = {
    homepage = "https://github.com/tzfun/etcd-workbench";
    description = "Etcd Workbench,现代化 etcd 桌面客户端";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "etcd-workbench";
  };
})
