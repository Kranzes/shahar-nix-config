{ lib, ... }:

let
  inherit (lib.generators) mkLuaInline;

  bind = key: action: opts: {
    _args = [
      key
      (mkLuaInline action)
    ]
    ++ lib.optional (opts != { }) opts;
  };
  exec = cmd: ''hl.dsp.exec_cmd("${cmd}")'';
  noctalia = cmd: exec "noctalia msg ${cmd}";

  workspaceBinds = lib.concatMap (
    n:
    let
      key = toString (lib.mod n 10);
    in
    [
      (bind "SUPER + ${key}" "hl.dsp.focus({ workspace = ${toString n} })" { })
      (bind "SUPER + SHIFT + ${key}" "hl.dsp.window.move({ workspace = ${toString n}, follow = false })"
        { }
      )
    ]
  ) (lib.range 1 10);
in
{
  home.sessionVariables.NIXOS_OZONE_WL = "1";

  wayland.windowManager.hyprland = {
    enable = true;
    # Both come from the NixOS module.
    package = null;
    portalPackage = null;
    # UWSM manages the session.
    systemd.enable = false;
    configType = "lua";

    settings = {
      monitor = lib.mkDefault [
        {
          output = "";
          mode = "preferred";
          position = "auto";
          scale = "auto";
        }
      ];

      config = {
        input = {
          kb_layout = "us,il";
          kb_options = "grp:alt_shift_toggle,ctrl:nocaps";
          follow_mouse = 2;
          touchpad = {
            natural_scroll = true;
            clickfinger_behavior = true;
            disable_while_typing = true;
          };
        };

        general = {
          layout = "dwindle";
          gaps_in = 4;
          gaps_out = 8;
          border_size = 2;
        };

        dwindle.preserve_split = true;

        decoration = {
          rounding = 10;
          blur.enabled = false;
          shadow.enabled = false;
        };

        animations.enabled = false;

        cursor.no_warps = true;

        misc = {
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
          middle_click_paste = false;
          mouse_move_enables_dpms = true;
          key_press_enables_dpms = true;
          force_default_wallpaper = 0;
          focus_on_activate = true;
        };
      };

      on._args = [
        "hyprland.start"
        (mkLuaInline ''
          function()
            hl.exec_cmd("noctalia")
          end
        '')
      ];

      bind = [
        (bind "SUPER + Return" (exec "ghostty +new-window") { })
        (bind "SUPER + Space" (noctalia "panel-toggle launcher") { })
        (bind "SUPER + S" (noctalia "panel-toggle control-center") { })
        (bind "SUPER + comma" (noctalia "settings-toggle") { })
        (bind "SUPER + Escape" (noctalia "session lock") { })
        (bind "ALT + Tab" (noctalia "window-switcher hold") { })
        (bind "SUPER + B" (exec "firefox") { })
        (bind "SUPER + E" (exec "nautilus") { })
        (bind "SUPER + W" "hl.dsp.window.close()" { })
        (bind "SUPER + SHIFT + W" "hl.dsp.window.kill()" { })
        (bind "SUPER + ALT + Q" "hl.dsp.exit()" { })
        (bind "SUPER + H" ''hl.dsp.focus({ direction = "left" })'' { })
        (bind "SUPER + J" ''hl.dsp.focus({ direction = "down" })'' { })
        (bind "SUPER + K" ''hl.dsp.focus({ direction = "up" })'' { })
        (bind "SUPER + L" ''hl.dsp.focus({ direction = "right" })'' { })
        (bind "SUPER + SHIFT + H" ''hl.dsp.window.swap({ direction = "left" })'' { })
        (bind "SUPER + SHIFT + J" ''hl.dsp.window.swap({ direction = "down" })'' { })
        (bind "SUPER + SHIFT + K" ''hl.dsp.window.swap({ direction = "up" })'' { })
        (bind "SUPER + SHIFT + L" ''hl.dsp.window.swap({ direction = "right" })'' { })
        (bind "SUPER + F" ''hl.dsp.window.fullscreen({ mode = "fullscreen" })'' { })
        (bind "SUPER + T" ''hl.dsp.window.float({ action = "toggle" })'' { })
        (bind "SUPER + V" ''hl.dsp.layout("togglesplit")'' { })
        (bind "Print" (noctalia "screenshot-region") { })
        (bind "XF86AudioPlay" (noctalia "media toggle") { locked = true; })
        (bind "XF86AudioNext" (noctalia "media next") { locked = true; })
        (bind "XF86AudioPrev" (noctalia "media previous") { locked = true; })
        (bind "XF86AudioMute" (noctalia "volume-mute") { locked = true; })
        (bind "XF86AudioRaiseVolume" (noctalia "volume-up") {
          locked = true;
          repeating = true;
        })
        (bind "XF86AudioLowerVolume" (noctalia "volume-down") {
          locked = true;
          repeating = true;
        })
        (bind "XF86MonBrightnessUp" (noctalia "brightness-up") {
          locked = true;
          repeating = true;
        })
        (bind "XF86MonBrightnessDown" (noctalia "brightness-down") {
          locked = true;
          repeating = true;
        })
        (bind "SUPER + mouse:272" "hl.dsp.window.drag()" { mouse = true; })
        (bind "SUPER + mouse:273" "hl.dsp.window.resize()" { mouse = true; })
      ]
      ++ workspaceBinds;

      window_rule = [
        {
          match.class = "^(dev\\.noctalia\\.Noctalia)$";
          float = true;
        }
      ];
    };
  };
}
