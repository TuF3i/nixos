{ pkgs, ... }: {
  # Python:全模块解释器 + 现代 Python 工具链
  # 项目隔离建议 uv venv / direnv;uv 也可直接管理 python 版本
  environment.systemPackages = with pkgs; [
    python3
    uv
    pyright
  ];
}
