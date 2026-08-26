#!/bin/sh

set -e

echo "Configurando Hyprland..."

mkdir -p ~/.config/hypr/
rm -rf ~/.config/hypr/hyprland.lua

cat > ~/.config/hypr/hyprland.lua << 'EOF'

------------------
---- MONITORS ----
------------------


hl.monitor({
    output   = "auto",
    mode     = "prefered",
    position = "auto",
    scale    = "auto",
})


---------------------
---- MY PROGRAMS ----
---------------------

-- Set programs that you use
local terminal    = "foot"
local fileManager = "dbus-run-session nautilus"
local menu        = "env GTK_OVERLAY_SCROLLING=0 wofi --show drun"


-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
hl.exec_cmd("noctalia &")
hl.exec_cmd("hyprlock &")
hl.exec_cmd("pipewire &")
hl.exec_cmd("pipewire-pulse &")
hl.exec_cmd("wireplumber")

end)


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------


hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")


-----------------------
----- PERMISSIONS -----
-----------------------


-- hl.config({
--   ecosystem = {
--     enforce_permissions = true,
--   },
-- })


-----------------------
---- LOOK AND FEEL ----
-----------------------

-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
    general = {
        gaps_in  = 5,
        gaps_out = 20,

        border_size = 2,

        col = {
            active_border   = { colors = {"rgba(ffffffff)", "rgba(ffffffff)"}, angle = 45 },
            inactive_border = "rgba(c2c2c2c2)",
        },

        -- Set to true to enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = false,

        -- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
        allow_tearing = false,

        layout = "dwindle",
    },

    decoration = {
        rounding       = 10,
        rounding_power = 2,

        -- Change transparency of focused and unfocused windows
        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = 0xee1a1a1a,
        },

        blur = {
            enabled   = true,
            size      = 7,
            passes    = 2,
            vibrancy  = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },
})

-- Default curves and animations, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1}    } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1}    } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}       } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1}    } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}     } })

-- Default springs
hl.curve("easy",           { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })

hl.animation({ leaf = "global",        enabled = true,  speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true,  speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true,  speed = 4.79, spring = "easy" })
hl.animation({ leaf = "windowsIn",     enabled = true,  speed = 4.1,  spring = "easy",         style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true,  speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true,  speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true,  speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true,  speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true,  speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true,  speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true,  speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true,  speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true,  speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true,  speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true,  speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true,  speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor",    enabled = true,  speed = 7,    bezier = "quick" })

-- Ref https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
-- "Smart gaps" / "No gaps when only"
-- uncomment all if you wish to use that.
-- hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
-- hl.workspace_rule({ workspace = "f[1]",   gaps_out = 0, gaps_in = 0 })
-- hl.window_rule({
--     name  = "no-gaps-wtv1",
--     match = { float = false, workspace = "w[tv1]" },
--     border_size = 0,
--     rounding    = 0,
-- })
-- hl.window_rule({
--     name  = "no-gaps-f1",
--     match = { float = false, workspace = "f[1]" },
--     border_size = 0,
--     rounding    = 0,
-- })

hl.window_rule({
    match = {
        class = "^foot$",
    },
    opacity = "0.80 override 0.60 override",
    rounding = 10,
})


hl.layer_rule({
  name = "noctalia",
  match = {
    namespace = "^noctalia-(bar|notification|dock|panel|attached-panel|osd|window-switcher|background).*",
  },

  ignore_alpha = 0.5, 
  blur = true,
  blur_popups = true,
})

hl.layer_rule({
  name = "wofi",
  match = {
  namespace = "^wofi$"
  },
  ignore_alpha = 0.5, 
  blur = true,
  blur_popups = true,
})


-- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more
hl.config({
    dwindle = {
        preserve_split = true, -- You probably want this
    },
})

-- See https://wiki.hypr.land/Configuring/Layouts/Master-Layout/ for more
hl.config({
    master = {
        new_status = "master",
    },
})

-- See https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/ for more
hl.config({
    scrolling = {
        fullscreen_on_one_column = true,
    },
})

----------------
----  MISC  ----
----------------

hl.config({
    misc = {
        force_default_wallpaper = -1,    -- Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo   = false, -- If true disables the random hyprland logo / anime girl background. :(
    },
})


---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout  = "latam",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        follow_mouse = 1,

        sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

        touchpad = {
            natural_scroll = true,
        },
    },
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})

-- Example per-device config
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/ for more
hl.device({
    name        = "epic-mouse-v1",
    sensitivity = -0.5,
})


---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER" 
local ipc = "noctalia msg "

-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
local closeWindowBind = hl.bind(mainMod .. " + Q", hl.dsp.window.close())
-- closeWindowBind:set_enabled(false)
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))    -- dwindle only
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("hyprlock"))

-- Screenshot binds
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("~/.config/hypr/screenshot-area.sh"))

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))


--noctalia binds

hl.bind(mainMod .. "+ R", hl.dsp.exec_cmd( ipc .. "panel-toggle launcher"))
hl.bind(mainMod .. "+S", hl.dsp.exec_cmd( ipc .. "panel-toggle control-center"))
hl.bind(mainMod .. "+comma", hl.dsp.exec_cmd( ipc .. "settings-toggle"))
hl.bind(mainMod .. "+ Tab", hl.dsp.exec_cmd(ipc .. "window-switcher"))

-- Media keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(ipc .. "volume-up"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(ipc .. "volume-down"))
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(ipc .. "volume-mute"))
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(ipc .. "brightness-up"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(ipc .. "brightness-down"))

-- Noctalia settings

hl.window_rule({
    match = { class = "dev.noctalia.Noctalia" },
    float = true,
    size = { 1080, 920 },
})


-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,             hl.dsp.focus({ workspace = i}))
    hl.bind(mainMod .. " + SHIFT + " .. key,     hl.dsp.window.move({ workspace = i }))
end

-- Example special workspace (scratchpad)
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })


-- Requires playerctl
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })


--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Example window rules that are useful

local suppressMaximizeRule = hl.window_rule({
    -- Ignore maximize requests from all apps. You'll probably like this.
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

-- Layer rules also return a handle.
-- local overlayLayerRule = hl.layer_rule({
--     name  = "no-anim-overlay",
--     match = { namespace = "^my-overlay$" },
--     no_anim = true,
-- })
-- overlayLayerRule:set_enabled(false)

-- Hyprland-run windowrule
hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },

    move  = "20 monitor_h-120",
    float = true,
})


EOF

cat > ~/.config/hypr/screenshot-area.sh << 'EOF'

#!/usr/bin/env bash

DIR="$HOME/Documentos/Screenshots"
mkdir -p "$DIR"

FILE="$DIR/screenshot_$(date +%Y%m%d_%H%M%S).png"

GEOM="$(slurp)" || exit 0

if grim -g "$GEOM" "$FILE"; then
    wl-copy < "$FILE"
    notify-send "Screenshot guardado" "$FILE" -i image.png
fi

EOF

cat > ~/.config/hypr/hyprlock.conf << 'EOF'


general {
    disable_loading_bar = true
    grace = 0
    hide_cursor = true
    no_fade_in = false
    no_fade_out = false
}


background {
    monitor =
    path = screenshot
    blur_passes = 3
    blur_size = 6
    brightness = 0.7
    contrast = 0.9
    saturate = 0.0
    noise = 0.01
    vibrancy = 0.1
}


input-field {
    monitor =
    size = 420, 60
    outline_thickness = 1
    dots_size = 0.25
    dots_spacing = 0.3
    dots_center = true
    outer_color = rgba(150, 150, 150, 0.45)
    inner_color = rgba(14, 14, 14, 0.20)
    font_color = rgb(237, 237, 237)
    fade_on_empty = true
    placeholder_text = 
    hide_input = false
    rounding = 16
    check_color = rgb(185, 185, 185)
    fail_color = rgb(200, 200, 200)
    fail_text = <i>$FAIL <b>($ATTEMPTS)</b></i>
    position = 0, 0
    halign = center
    valign = center
}

label {
    monitor =
    text = cmd[update:1000] echo "$(date +"%H:%M")"
    color = rgba(237, 237, 237, 0.94)
    font_size = 72
    font_family = Roboto Mono Bold
    position = 0, 220
    halign = center
    valign = center
}

label {
    monitor =
    text = cmd[update:1000] echo "$(date +"%A, %d de %B")"
    color = rgba(237, 237, 237, 0.60)
    font_size = 16
    font_family = Roboto Mono
    position = 0, 140
    halign = center
    valign = center
}

EOF

mkdir -p ~/.config/noctalia/palettes
cat > ~/.config/noctalia/palettes/Slate.json << 'EOF'

{
  "dark": {
    "mPrimary": "#8B9AAB",
    "mOnPrimary": "#101419",

    "mSecondary": "#697787",
    "mOnSecondary": "#F0F3F6",

    "mTertiary": "#A5B0BC",
    "mOnTertiary": "#101419",

    "mError": "#B56B72",
    "mOnError": "#FFFFFF",

    "mSurface": "#0B0F14",
    "mOnSurface": "#E5E9EE",

    "mSurfaceVariant": "#171D24",
    "mOnSurfaceVariant": "#AAB3BE",

    "mOutline": "#3A4552",
    "mShadow": "#000000",

    "mHover": "#222A33",
    "mOnHover": "#F0F3F6",

    "terminal": {
      "background": "#0B0F14",
      "foreground": "#D9DEE5",

      "black": "#0B0F14",
      "red": "#B56B72",
      "green": "#8A9B8A",
      "yellow": "#A9A18A",
      "blue": "#71849A",
      "magenta": "#918A9A",
      "cyan": "#78949A",
      "white": "#D9DEE5",

      "bright_black": "#4A5561",
      "bright_red": "#C47B82",
      "bright_green": "#9BAE9B",
      "bright_yellow": "#B9B19A",
      "bright_blue": "#8799AE",
      "bright_magenta": "#A29BAB",
      "bright_cyan": "#8BA7AD",
      "bright_white": "#F5F7FA"
    }
  }
}


EOF

mkdir -p ~/.config/qt5ct/colors
mkdir -p ~/.config/qt5ct/qss

cat > ~/.config/qt5ct/qt5ct.conf << 'EOF'

[Appearance]
color_scheme_path=/usr/share/qt5ct/colors/darker.conf
custom_palette=true
standard_dialogs=default
style=Fusion

[Fonts]
fixed="Sans Serif,9,-1,5,50,0,0,0,0,0"
general="Sans Serif,9,-1,5,50,0,0,0,0,0"

[Interface]
activate_item_on_single_click=1
buttonbox_layout=0
cursor_flash_time=1000
dialog_buttons_have_icons=1
double_click_interval=400
gui_effects=@Invalid()
keyboard_scheme=2
menus_have_icons=true
show_shortcuts_in_context_menus=true
stylesheets=@Invalid()
toolbutton_style=4
underline_shortcut=1
wheel_scroll_lines=3

[SettingsWindow]
geometry=@ByteArray(\x1\xd9\xd0\xcb\0\x3\0\0\0\0\0\0\0\0\0\0\0\0\x2\x8d\0\0\x2\xb1\0\0\0\0\0\0\0\0\0\0\x2\x96\0\0\x2\xb5\0\0\0\0\x2\0\0\0\x5V\0\0\0\0\0\0\0\0\0\0\x2\x8d\0\0\x2\xb1)

[Troubleshooting]
force_raster_widgets=1
ignored_applications=@Invalid()


EOF

mkdir -p ~/.config/qt6ct/colors
mkdir -p ~/.config/qt6ct/qss

cat > ~/.config/qt6ct/qt6ct.conf << 'EOF'

[Appearance]
color_scheme_path=/usr/share/qt6ct/colors/darker.conf
custom_palette=true
standard_dialogs=default
style=Fusion

[Fonts]
fixed="Sans Serif,9,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,,0,0"
general="Sans Serif,9,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,,0,0"

[Interface]
activate_item_on_single_click=1
buttonbox_layout=0
cursor_flash_time=1000
dialog_buttons_have_icons=1
double_click_interval=400
gui_effects=@Invalid()
keyboard_scheme=2
menus_have_icons=true
show_shortcuts_in_context_menus=true
stylesheets=@Invalid()
toolbutton_style=4
underline_shortcut=1
wheel_scroll_lines=3

[SettingsWindow]
geometry=@ByteArray(\x1\xd9\xd0\xcb\0\x3\0\0\0\0\0\0\0\0\0\0\0\0\x2\x8d\0\0\x2\xb1\0\0\0\0\0\0\0\0\0\0\x2\x8d\0\0\x2\xb1\0\0\0\0\x2\0\0\0\x5V\0\0\0\0\0\0\0\0\0\0\x2\x8d\0\0\x2\xb1)

[Troubleshooting]
force_raster_widgets=1
ignored_applications=@Invalid()


EOF


mkdir -p ~/.config/wofi

cat > ~/.config/wofi/config << 'EOF'

show=drun
prompt=Search
width=500
height=400
lines=5
columns=1
location=center
layer=overlay
allow_images=true
image_size=32
term=foot
hide_scroll=true
no_actions=true


EOF

cat > ~/.config/wofi/style.css << 'EOF' 

@define-color base rgba(14, 14, 14, 0.78);
@define-color raised rgba(32, 32, 32, 0.86);
@define-color raised_focus rgba(42, 42, 42, 0.90);

@define-color border_gray rgba(150, 150, 150, 0.45);
@define-color border_gray_strong rgba(185, 185, 185, 0.60);

@define-color text #EDEDED;
@define-color hover rgba(255, 255, 255, 0.05);
@define-color selected rgba(255, 255, 255, 0.10);

* {
    font-family: "Roboto Mono", "Roboto Flex", monospace;
    font-size: 14px;
    font-weight: 600;
    color: @text;
}

window,
#window {
    background-color: @base;
    border-radius: 20px;
    border-width: 1px;
    border-style: solid;
    border-color: @border_gray;
    padding: 20px;
}

#outer-box,
#inner-box,
#scroll,
#entry,
#text {
    background-color: transparent;
    border-width: 0;
}

#outer-box {
    padding: 0;
    margin: 0;
}

#inner-box {
    padding: 0;
    margin: 0;
}

#scroll {
    padding: 0;
    margin: 0;
}


#input {
    background-color: @raised;
    border-radius: 16px;
    border-width: 1px;
    border-style: solid;
    border-color: @border_gray;
    padding: 14px 16px;
    margin: 0 0 16px 0;
}


#input:focus {
    background-color: @raised_focus;
    border-color: @border_gray_strong;
    box-shadow: 0 12px 28px rgba(0, 0, 0, 0.45);
}

#input image {
    padding-right: 10px;
}


#entry {
    padding: 8px 16px 8px 24px;
    margin: 4px 0;
    border-radius: 12px;
}

#entry:hover {
    background-color: @hover;
}

#entry:selected {
    background-color: @selected;
}

#entry:selected #text {
    color: #FFFFFF;
}


#img {
    margin-right: 18px;
    opacity: 0.90;
    -gtk-icon-style: symbolic;
}

#entry:selected #img {
    opacity: 1.0;
}


#entry arrow,
scrollbar button,
scrollbar.overlay-indicator,
scrollbar.overlay-indicator slider,
scrollbar.overlay-indicator trough {
    background-color: transparent;
    background-image: none;
    border-width: 0;
    min-width: 0;
    min-height: 0;
    padding: 0;
    margin: 0;
    color: transparent;
}


#entry:focus,
#entry:selected:focus,
#input:focus {
    outline-style: none;
    outline-width: 0;
}


EOF


mkdir -p ~/.config/foot

cat > ~/.config/foot/foot.ini << 'EOF'

font=Roboto Mono:size=15
letter-spacing=0
dpi-aware=yes

initial-window-size-chars=100x30
pad=16x16 center
[bell]
[scrollback]
lines=10000
[url]
# launch=xdg-open ${url}
# label-letters=sadfjklewcmpgh
# osc8-underline=url-mode
# protocols=http, https, ftp, ftps, file, gemini, gopher
# uri-characters=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_.,~:;/?#@!$&%*+="'()[]

[cursor]
style=beam
# color=<inverse foreground/background>
blink=no
# beam-thickness=1.5
# underline-thickness=<font underline thickness>

[mouse]
hide-when-typing=yes
# alternate-scroll-mode=yes

[tweak]
font-monospace-warn=no

[colors-dark]
alpha=0.60
background=0e0e0e
foreground=e6e6e6

# Normal/regular colors (color palette 0-7)
regular0=0e0e0e  # black
regular1=7d7d7d  # red
regular2=969696  # green
regular3=aeaeae  # yellow
regular4=8a8a8a  # blue
regular5=a0a0a0  # magenta
regular6=c4c4c4  # cyan
regular7=dedede  # white

# Bright colors (color palette 8-15)
bright0=444444   # bright black
bright1=909090   # bright red
bright2=a8a8a8   # bright green
bright3=c0c0c0   # bright yellow
bright4=9c9c9c   # bright blue
bright5=b4b4b4   # bright magenta
bright6=d7d7d7   # bright cyan
bright7=f4f4f4   # bright white

## dimmed colors (see foot.ini(5) man page)
# dim0=<not set>
# ...
# dim7=<not-set>

## The remaining 256-color palette
# 16 = <256-color palette #16>
# ...
# 255 = <256-color palette #255>

## Misc colors
selection-background=cfcfcf
selection-foreground=0e0e0e
# jump-labels=<regular0> <regular3>
# urls=<regular3>
# scrollback-indicator=<regular0> <bright4>

[csd]
# preferred=server
# size=26
# font=<primary font>
# color=<foreground color>
# hide-when-typing=no
# border-width=0
# border-color=<csd.color>
# button-width=26
# button-color=<background color>
# button-minimize-color=<regular4>
# button-maximize-color=<regular2>
# button-close-color=<regular1>

[key-bindings]
# scrollback-up-page=Shift+Page_Up
# scrollback-up-half-page=none
# scrollback-up-line=none
# scrollback-down-page=Shift+Page_Down
# scrollback-down-half-page=none
# scrollback-down-line=none
# clipboard-copy=Control+Shift+c XF86Copy
# clipboard-paste=Control+Shift+v XF86Paste
# primary-paste=Shift+Insert
# search-start=Control+Shift+r
# font-increase=Control+plus Control+equal Control+KP_Add
# font-decrease=Control+minus Control+KP_Subtract
# font-reset=Control+0 Control+KP_0
# spawn-terminal=Control+Shift+n
# minimize=none
# maximize=none
# fullscreen=none
# pipe-visible=[sh -c "xurls | fuzzel | xargs -r firefox"] none
# pipe-scrollback=[sh -c "xurls | fuzzel | xargs -r firefox"] none
# pipe-selected=[xargs -r firefox] none
# show-urls-launch=Control+Shift+u
# show-urls-copy=none
# show-urls-persistent=none
# prompt-prev=Control+Shift+z
# prompt-next=Control+Shift+x
# unicode-input=none
# noop=none

[search-bindings]
# cancel=Control+g Control+c Escape
# commit=Return
# find-prev=Control+r
# find-next=Control+s
# cursor-left=Left Control+b
# cursor-left-word=Control+Left Mod1+b
# cursor-right=Right Control+f
# cursor-right-word=Control+Right Mod1+f
# cursor-home=Home Control+a
# cursor-end=End Control+e
# delete-prev=BackSpace
# delete-prev-word=Mod1+BackSpace Control+BackSpace
# delete-next=Delete
# delete-next-word=Mod1+d Control+Delete
# extend-to-word-boundary=Control+w
# extend-to-next-whitespace=Control+Shift+w
# clipboard-paste=Control+v Control+Shift+v Control+y XF86Paste
# primary-paste=Shift+Insert

[url-bindings]
# cancel=Control+g Control+c Control+d Escape
# toggle-url-visible=t

[text-bindings]
# \x03=Mod4+c  # Map Super+c -> Ctrl+c

[mouse-bindings]
# selection-override-modifiers=Shift
# primary-paste=BTN_MIDDLE
# select-begin=BTN_LEFT
# select-begin-block=Control+BTN_LEFT
# select-extend=BTN_RIGHT
# select-extend-character-wise=Control+BTN_RIGHT
# select-word=BTN_LEFT-2
# select-word-whitespace=Control+BTN_LEFT-2
# select-row=BTN_LEFT-3

# vim: ft=dosini


EOF

mkdir -p ~/.config/gtk-4.0
cat > ~/.config/gtk-4.0/settings.ini << 'EOF'

[Settings]
gtk-theme-name = Adwaita
gtk-application-prefer-dark-theme = true
gtk-icon-theme-name = Adwaita


EOF

mkdir -p ~/.config/gtk-3.0
cat > ~/.config/gtk-3.0/settings.ini << 'EOF'

[Settings]
gtk-theme-name = Adwaita
gtk-application-prefer-dark-theme = true
gtk-icon-theme-name = Adwaita


EOF

mkdir -p ~/.local/state/noctalia

cat > ~/.local/state/noctalia/setting.toml << 'EOF'

config_version = 13

[dock]
launcher_custom_image = "/usr/share/icons/hicolor/scalable/apps/void-logo-notext.svg"
launcher_icon = "grid-dot"
launcher_position = "start"
position = "left"
reserve_space = false
smart_auto_hide = true

[lockscreen]
enabled = false

[lockscreen_widgets]
enabled = false
schema_version = 2
widget_order = [ "lockscreen-login-box@eDP-1" ]

    [lockscreen_widgets.grid]
    cell_size = 16
    major_interval = 4
    visible = true

    [lockscreen_widgets.widget."lockscreen-login-box@eDP-1"]
    box_height = 196.0
    box_width = 720.0
    cx = 683.0
    cy = 586.0
    output = "eDP-1"
    placement_height = 768.0
    placement_width = 1366.0
    rotation = 0.0
    type = "login_box"

        [lockscreen_widgets.widget."lockscreen-login-box@eDP-1".settings]
        background_color = "surface_variant"
        background_opacity = 0.88
        background_radius = 12.0
        center_password_text = false
        input_opacity = 1.0
        input_radius = 6.0
        layout = "regular"
        show_caps_lock = true
        show_keyboard_layout = true
        show_login_button = true
        show_media = true
        show_session_buttons = true
        show_unlock_hint = true
        show_weather = true

[shell]
app_icon_colorize = true
corner_radius_scale = 1.3500000201165676
font_family = "Roboto Flex"
settings_window_translucent = true

    [shell.panel]
    launcher_position = "bottom_center"
    transparency_mode = "glass"
    wallpaper_placement = "floating"

[theme]
builtin = "Noctalia"
community_palette = "Oxocarbon"
custom_palette = "Slate"
mode = "dark"
source = "custom"
wallpaper_scheme = "m3-content"

[wallpaper]
directory = "/home/void/Pictures/Wallpapers"

    [wallpaper.default]
    path = "/usr/share/noctalia/assets/noctalia-wallpaper.png"

    [wallpaper.last]
    path = "/usr/share/noctalia/assets/noctalia-wallpaper.png"

EOF

cat > ~/.bashrc << 'EOF'

# .bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='\w ❯ '


EOF

cat > ~/.bash_profile << 'EOF'

# .bash_profile

# Get the aliases and functions
[ -f $HOME/.bashrc ] && . $HOME/.bashrc

export GTK_THEME=Adwaita:dark
export QT_QPA_PLATFORMTHEME=qt5ct
export QT_QPA_PLATFORMTHEME=qt6ct


EOF








echo "Configuración de Hyprland, Noctalia y foot completada. Puedes inicar hyprland con el comando 'start-hyprland' desde TTY."
echo "  - SUPER + RETURN: Abre terminal (foot)"
echo "  - SUPER + Q: Cierra ventana activa"
echo "  - SUPER + R: Abre el lanzador de apliaciones"
echo "  - SUPER + S: Abre la barra desplegable de noctalia"
echo "  - Noctalia se inicia automáticamente con Hyprland"
