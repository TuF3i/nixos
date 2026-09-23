{ pkgs, ... }: {
  programs.git = {
    enable = true;

    settings = {
      user.name = "TuF3i";
      user.email = "tuf3i.do@outlook.com";

      init.defaultBranch = "main";
      push.autoSetupRemote = true;
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  home.packages = with pkgs; [
    fastfetch
    btop
    eza
    tldr
    ripgrep
    fd
  ];
}
