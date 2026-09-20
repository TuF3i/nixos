{ pkgs, ... }: {
  programs.direnv.enable = true;

  programs.zsh = {
    enable = true;
    shellInit = ''
      eval "$(${pkgs.direnv}/bin/direnv hook zsh)"
      eval "$(${pkgs.fzf}/bin/fzf --zsh)"
    '';
  };
}
