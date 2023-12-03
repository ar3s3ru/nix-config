{ config, pkgs, lib, ... }:
let
  yabai = "/opt/homebrew/bin/yabai";
in
{
  home.file.yabai = {
    executable = true;
    target = ".config/yabai/yabairc";
    text = ''
      #!/usr/bin/env sh

      # load scripting addition
      sudo ${yabai} --load-sa
      ${yabai} -m signal --add event=dock_did_restart action="sudo ${yabai} --load-sa"

      ${yabai} -m config layout bsp
      ${yabai} -m config window_placement second_child
      ${yabai} -m config auto_balance off
      ${yabai} -m config split_ratio 0.5
      ${yabai} -m config window_topmost on
      ${yabai} -m config focus_follows_mouse autofocus
      ${yabai} -m config mouse_follows_focus on
      ${yabai} -m config window_shadow float
      ${yabai} -m config window_border off

      ${yabai} -m config top_padding    20
      ${yabai} -m config bottom_padding 20
      ${yabai} -m config left_padding   20
      ${yabai} -m config right_padding  20
      ${yabai} -m config window_gap     10

      # rules
      ${yabai} -m rule --add app="^System Preferences$" manage=off

      # spaces
      ${yabai} -m space 1 --label term
      ${yabai} -m space 2 --label www
      ${yabai} -m space 3 --label code
      ${yabai} -m space 4 --label ide
      ${yabai} -m space 5 --label chat
      ${yabai} -m space 10 --label slack

      echo "yabai configuration loaded.."
    '';
  };

  home.file.skhd =
    let
      brew = "/opt/homebrew/bin/brew";

      mod = "alt";

      left = "j";
      right = "l";
      top = "i";
      bottom = "k";
    in
    {
      target = ".config/skhd/skhdrc";
      text = ''
        :: default

        # terminal
        default < ${mod} - return : ${pkgs.alacritty}/bin/alacritty

        # split mode
        default < ${mod} - b : ${yabai} -m config split_type horizontal
        default < ${mod} - v : ${yabai} -m config split_type vertical

        # focus window
        default < ${mod} - ${left} : ${yabai} -m window --focus west
        default < ${mod} - ${bottom} : ${yabai} -m window --focus south
        default < ${mod} - ${top} : ${yabai} -m window --focus north
        default < ${mod} - ${right} : ${yabai} -m window --focus east

        # rearrange windows
        default < shift + ${mod} - ${left} : ${yabai} -m window --swap west
        default < shift + ${mod} - ${bottom} : ${yabai} -m window --swap south
        default < shift + ${mod} - ${top} : ${yabai} -m window --swap north
        default < shift + ${mod} - ${right} : ${yabai} -m window --swap east

        # move spaces
        default < ${mod} - 1 : ${yabai} -m space --focus 1
        default < ${mod} - 2 : ${yabai} -m space --focus 2
        default < ${mod} - 3 : ${yabai} -m space --focus 3
        default < ${mod} - 4 : ${yabai} -m space --focus 4
        default < ${mod} - 5 : ${yabai} -m space --focus 5
        default < ${mod} - 6 : ${yabai} -m space --focus 6
        default < ${mod} - 7 : ${yabai} -m space --focus 7
        default < ${mod} - 8 : ${yabai} -m space --focus 8
        default < ${mod} - 9 : ${yabai} -m space --focus 9
        default < ${mod} - 0 : ${yabai} -m space --focus 10

        # move windows
        default < shift + ${mod} - 1 : ${yabai} -m window --space 1
        default < shift + ${mod} - 2 : ${yabai} -m window --space 2
        default < shift + ${mod} - 3 : ${yabai} -m window --space 3
        default < shift + ${mod} - 4 : ${yabai} -m window --space 4
        default < shift + ${mod} - 5 : ${yabai} -m window --space 5
        default < shift + ${mod} - 6 : ${yabai} -m window --space 6
        default < shift + ${mod} - 7 : ${yabai} -m window --space 7
        default < shift + ${mod} - 8 : ${yabai} -m window --space 8
        default < shift + ${mod} - 9 : ${yabai} -m window --space 9
        default < shift + ${mod} - 0 : ${yabai} -m window --space 10

        # resizing
        :: resize

        ${mod} - r ; resize
        resize < l : ${yabai} -m window --resize left:-20:0
        resize < j : ${yabai} -m window --resize left:20:0
        resize < i : ${yabai} -m window --resize top:0:20
        resize < k : ${yabai} -m window --resize bottom:0:20
        resize < escape ; default

        # float / unfloat window and center on screen
        default < shift + ${mod} - space : ${yabai} -m window --toggle float; \
                                           ${yabai} -m window --grid 4:4:1:1:2:2

        # fullscreen
        default < ${mod} - f : ${yabai} -m window --toggle zoom-fullscreen
        default < shift + ${mod} - f : ${yabai} -m window --toggle native-fullscreen

        # reload all the things!
        default < ${mod} - c : ${brew} yabai --restart-service
        default < shift + ${mod} - c : ${brew} skhd --restart-service
      '';
    };
}
