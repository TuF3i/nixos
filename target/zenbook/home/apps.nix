{ pkgs, ... }: {
  # 鼠标光标主题;niri 会读取 XCURSOR_THEME/SIZE 环境变量作为默认光标
  home.pointerCursor = {
    enable = true;
    package = pkgs.catppuccin-cursors.mochaDark;
    name = "catppuccin-mocha-dark-cursors";
    size = 24;
    gtk.enable = true;
  };

  programs.ghostty = {
    enable = true;

    # 自定义主题(对应原 userdata/config/ghostty/themes/dankcolors)
    themes.dankcolors = {
      background = "#141218";
      foreground = "#e6e0e9";
      cursor-color = "#d0bcff";
      selection-background = "#4f378b";
      selection-foreground = "#e6e0e9";

      palette = [
        "0=#141218"
        "1=#ff728f"
        "2=#7fff9a"
        "3=#ffda72"
        "4=#bca5f2"
        "5=#4e3d76"
        "6=#D0BCFF"
        "7=#f4efff"
        "8=#434149"
        "9=#ff9fb2"
        "10=#a5ffb8"
        "11=#ffe7a5"
        "12=#d7c6ff"
        "13=#ded0ff"
        "14=#e9e0ff"
        "15=#faf8ff"
      ];
    };

    settings = {
      # Font
      font-family = "FiraCode Nerd Font";
      font-style = "Regular";
      font-size = 12;

      # Window
      window-decoration = false;
      window-padding-x = 12;
      window-padding-y = 12;
      background-opacity = 1.0;
      background-blur-radius = 32;

      # Cursor
      cursor-style = "underline";
      cursor-style-blink = true;

      # Scrollback
      scrollback-limit = 3023;

      # Terminal features
      mouse-hide-while-typing = true;
      copy-on-select = false;
      confirm-close-surface = false;
      app-notifications = false;

      # Keybindings
      keybind = [
        "ctrl+shift+n=new_window"
        "ctrl+t=new_tab"
        "ctrl+plus=increase_font_size:1"
        "ctrl+minus=decrease_font_size:1"
        "ctrl+zero=reset_font_size"
        "shift+enter=text:\\n"
      ];

      # Material 3 UI elements
      unfocused-split-opacity = 0.7;
      unfocused-split-fill = "#44464f";

      gtk-titlebar = false;
      gtk-single-instance = true;

      # Shell integration
      shell-integration = "detect";
      shell-integration-features = "cursor,sudo,title,no-cursor";

      theme = "dankcolors";
    };
  };
}
