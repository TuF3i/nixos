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

  # Kitty:第二终端模拟器,视觉与 ghostty 对齐
  # (dankcolors 同源配色、FiraCode Nerd Font、下划线光标、无边框)
  programs.kitty = {
    enable = true;

    font = {
      package = pkgs.nerd-fonts.fira-code;
      name = "FiraCode Nerd Font";
      size = 12;
    };

    settings = {
      # Dankcolors 配色:与 ghostty themes.dankcolors 完全同源
      background = "#141218";
      foreground = "#e6e0e9";
      cursor = "#d0bcff";
      selection_background = "#4f378b";
      selection_foreground = "#e6e0e9";

      color0 = "#141218";
      color1 = "#ff728f";
      color2 = "#7fff9a";
      color3 = "#ffda72";
      color4 = "#bca5f2";
      color5 = "#4e3d76";
      color6 = "#d0bcff";
      color7 = "#f4efff";
      color8 = "#434149";
      color9 = "#ff9fb2";
      color10 = "#a5ffb8";
      color11 = "#ffe7a5";
      color12 = "#d7c6ff";
      color13 = "#ded0ff";
      color14 = "#e9e0ff";
      color15 = "#faf8ff";

      # Window(对应 ghostty:无边框、12px 内边距、不透明)
      hide_window_decorations = "yes";
      window_padding_width = 12;
      background_opacity = "1.0";

      # Cursor(对应 ghostty:下划线 + 闪烁)
      cursor_shape = "underline";
      cursor_blink_interval = "1.0";

      # Scrollback(行数按 kitty 单位放大近似 ghostty 的 3023 行视图)
      scrollback_lines = 10000;

      # Terminal features
      mouse_hide_wait = "2.0";
      copy_on_select = false;
      confirm_os_window_close = 0;

      # Shell integration
      shell_integration = "enabled";

      # Material 3 分屏观感(对应 ghostty unfocused-split)
      inactive_text_alpha = "0.7";
    };

    keybindings = {
      # 对应 ghostty 的常用键位
      "ctrl+shift+n" = "new_os_window";
      "ctrl+t" = "new_tab";
      "ctrl+plus" = "change_font_size all +1.0";
      "ctrl+minus" = "change_font_size all -1.0";
      "ctrl+zero" = "change_font_size all 0";
      "shift+enter" = "new_window_with_cwd";
    };
  };
}
