{ pkgs, ... }: {
  # Rust 工具链(nix 原生,无 rustup)+ LSP/格式化/lint
  # 项目级锁定工具链建议用 direnv + fenix/oxalica overlays
  environment.systemPackages = with pkgs; [
    rustc
    cargo
    rustfmt
    clippy
    rust-analyzer
  ];
}
