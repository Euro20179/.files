local exec = hl.exec_cmd

local wsr = hl.workspace_rule
local wr = hl.window_rule

local submap_reset = "hyprctl dispatch submap reset"

local mod = "SUPER"

local workspaces = {
    BracketLeft =  "1",
    BracketRight =  "2",
    Minus =  "3",
    Equal =  "4",
    Backslash =  "5",
    Backspace =  "6",
    ['9'] =  "7",
}

local workspace_order = {
    ["DP-1"] = {
        "1",
        "2",
        "3",
        "4",
    },
    ["HDMI-A-1"] = {
        "5",
        "6",
        "7",
    }
}

local function indexOf(tbl, val)
    for i, v in ipairs(tbl) do
        if v == val then
            return i
        end
    end
end

local function partial(fn, ...)
    local args = ...
    return function()
        fn(args)
    end
end

local function attempt_refocus(focus)
    local cur = hl.get_active_window()
    hl.dispatch(hl.dsp.focus(focus))
    local now = hl.get_active_window()
    return cur ~= now
end

local function get_next_ws(dir)
    local mon = hl.get_active_monitor().name
    local cur_ws = hl.get_active_workspace().id

    local idx = indexOf(workspace_order[mon], tostring(cur_ws))
    if idx == nil then
        return tostring(cur_ws + dir)
    else idx = idx + dir end

    if idx < 1 then
        idx = #(workspace_order[mon])
    elseif idx > #(workspace_order[mon]) then
        return workspace_order[mon][1]
    end

    return workspace_order[mon][idx]
end

local function goto_next_ws(dir)
    hl.dispatch(hl.dsp.focus{workspace = get_next_ws(dir)})
end

local function run(cmd)
    return partial(hl.exec_cmd, cmd)
end

---@param key string
---@param exec function|HL.Dispatcher
---@param extra HL.BindOptions | nil
local function mbind(key, exec, extra)
    hl.bind(mod .. " + " .. key, exec, extra)
end

hl.monitor{
    output = "DP-1",
    mode = "1920x1080@165.003006",
    position = "0x0",
}

hl.monitor{
    output = "DP-2",
    disabled = true
}

hl.config {
    general = {
        allow_tearing = true,
        gaps_in = 0,
        gaps_out = 5,
        border_size = 1,
        layout = "master",
        col = {
            inactive_border = "rgba(00000000)",
            active_border = "rgb(89DCEB)",
        }
    },
    decoration = {
        rounding = 5,
        dim_inactive = true,
        dim_strength = 0.15,
        blur = {
            new_optimizations = true,
            xray = false,
            noise = 0.1,
            size = 3,
            passes = 2,
            special = true,
            popups = true
        },
        shadow = {
            enabled = false
        },
    },
    ecosystem = {
        no_update_news = true
    },
    input = {
        repeat_rate = 75,
        repeat_delay = 250,
        numlock_by_default = true,
        follow_mouse = 1,
    },
    misc = {
        render_unfocused_fps = 30,
    },
}

hl.animation {
    leaf = "windows",
    speed = 1,
    enabled = true,
    bezier = "default"
}

hl.animation {
    leaf = "workspaces",
    style = "slidevert",
    enabled = true,
    speed = 1,
    bezier = "default"
}

mbind("XF86AudioMute", partial(hl.exec_cmd, "eject -T"))

mbind("v", run "scr-wayland")
mbind("SHIFT+v", run "scr-wayland '' '' 'no-save'")

mbind("F3", run "tv-mode")

-- Audio {{{

local VOLUME_5_LOWER=[[wpctl set-volume "@DEFAULT_AUDIO_SINK@" 5%- && send-volume-notif lower]]
local VOLUME_1_LOWER=[[wpctl set-volume "@DEFAULT_AUDIO_SINK@" 1%- && send-volume-notif lower]]
local VOLUME_5_HIGHER=[[wpctl set-volume "@DEFAULT_AUDIO_SINK@" 5%+ && send-volume-notif lower]]
local VOLUME_1_HIGHER=[[wpctl set-volume "@DEFAULT_AUDIO_SINK@" 1%+ && send-volume-notif lower]]

mbind("F7", run(VOLUME_5_LOWER))
hl.bind("XF86AudioLowerVolume", run(VOLUME_5_LOWER))
mbind("SHIFT+F7", run(VOLUME_1_LOWER))
hl.bind("SHIFT+XF86AudioLowerVolume", run(VOLUME_1_LOWER))

mbind("F8", run(VOLUME_5_HIGHER))
hl.bind("XF86AudioRaiseVolume", run(VOLUME_5_HIGHER))
mbind("SHIFT+F8", run(VOLUME_1_HIGHER))
hl.bind("SHIFT+XF86AudioRaiseVolume", run(VOLUME_1_HIGHER))
-- }}}

-- Mullvad {{{
mbind("F1", run "mullvad-sxhkd")
hl.bind("SHIFT+F1", run 'notify-send "$(mullvad status)"')
mbind("F2", run [==[mullvad relay list |
                        grep "^[[:alpha:]]" |
                        rofi -dmenu -theme nord |
                        xargs mullvad relay set location ]==]) -- }}}

-- applications {{{
mbind("Return", run "$TERMINAL")
mbind("SHIFT+Return", run "mullvad-exclude $TERMINAL")
mbind("e", run "$MATRIX")
mbind("SHIFT+e", run "$EMAIL")
mbind("SHIFT+c", run "$CALENDAR")
mbind("T", run "$BROWSER")
hl.bind("XF86HomePage", run "$BROWSER")
mbind("SHIFT+t", run "$BROWSER_LITE")
mbind("ALT+t", run "_BROWSER_NO_PRIVACY")
mbind("z", run "$TERMINAL -e $SYSMON")
mbind("SHIFT+z", run "$TERMINAL -t foot-direct -e nvtop")

mbind("Semicolon", run "pick-emoji")
mbind("SHIFT+Semicolon", run "pick-reaction-image")
mbind("p", run [=[clr="$(hyprpicker -n)" && [ "$clr" ] && $TERMINAL -a goker goker "${clr}"]=])

mbind("x", run "cp-pass")
mbind("SHIFT+x", run "cp-pass otp")

mbind("i", run [[foot -a nvim-float nvim -S "$HOME/.local/vim-scripts/clipedit.vim"]])
mbind("SHIFT+i", run "foot -a nvim-float nvim-calc")
mbind("c", run "d-calc")

mbind("r", run "os-menu")
-- }}}

mbind("g", partial(hl.exec_cmd, "wlr-which-key -k g"))
mbind("b", partial(hl.exec_cmd, "wlr-which-key -k b"))

-- WM Stuff {{{
mbind("ALT+R", hl.dsp.exit())

mbind("q", hl.dsp.window.close())

mbind("f", hl.dsp.window.fullscreen())
mbind("space", hl.dsp.window.float{toggle = true})
mbind("SHIFT+p", hl.dsp.window.pin())

mbind("h", hl.dsp.focus{direction = "left"})
mbind("j", function()
    if attempt_refocus({direction = "down"}) == false then
        goto_next_ws(1)
    end
end)
mbind("k", function()
    if attempt_refocus({direction = "up"}) == false then
        goto_next_ws(-1)
    end
end)
mbind("l", hl.dsp.focus{direction = "right"})

mbind("Comma", run "select-window")

mbind("SHIFT+h", hl.dsp.window.move{direction = "left"})
mbind("SHIFT+l", hl.dsp.window.move{direction = "right"})
mbind("SHIFT+k", hl.dsp.window.move{direction = "up"})
mbind("SHIFT+j", hl.dsp.window.move{direction = "down"})
mbind("SHIFT+ALT+h", hl.dsp.window.swap{direction = "left"})
mbind("SHIFT+ALT+l", hl.dsp.window.swap{direction = "right"})
mbind("SHIFT+ALT+k", hl.dsp.window.swap{direction = "up"})
mbind("SHIFT+ALT+j", hl.dsp.window.swap{direction = "down"})

mbind("ALT+h", hl.dsp.window.resize{x = "-20", y = 0, relative = true}, {repeating = true})
mbind("ALT+l", hl.dsp.window.resize{x = "20", y = 0, relative = true}, {repeating = true})
mbind("ALT+k", hl.dsp.window.resize{x = "0", y = 20, relative = true}, {repeating = true})
mbind("ALT+j", hl.dsp.window.resize{x = "0", y = -20, relative = true}, {repeating = true})

mbind("period", hl.dsp.focus{monitor = "+1"})
mbind("SHIFT+period", hl.dsp.window.move({monitor = "+1"}))

mbind("mouse:272", hl.dsp.window.drag(),   { mouse = true })
mbind("mouse:273", hl.dsp.window.resize(), { mouse = true })

mbind("ALT+Semicolon", run "lock")
mbind("Apostrophe", run "linkding-cli search")

for key, ws_name in pairs(workspaces) do
    mbind(key, hl.dsp.focus{ workspace = ws_name })
    mbind("SHIFT+" .. key, hl.dsp.window.move { workspace = ws_name })
end

-- }}}

wsr {
    workspace = "1",
    monitor = "DP-1",
    default_name = "1st",
    layout = "scrolling"
}
wsr {
    workspace = "2",
    monitor = "DP-1",
    default_name = "2nd"
}
wsr {
    workspace = "3",
    monitor = "DP-1",
    default_name = "3rd",
}
wsr {
    workspace = "4",
    monitor = "DP-1",
    default_name = "email",
    layout = "scrolling"
}

wsr {
    workspace = "5",
    monitor = "HDMI-A-1",
    default = true,
    layout = "scrolling",
    default_name = "chat"
}

wsr {
    workspace = "6",
    monitor = "HDMI-A-1",
    default_name = "O-2nd"
}

wsr {
    workspace = "7",
    monitor = "HDMI-A-1",
    default_name = "ootw"
}

wr {
    name = "osu-on-first",
    match = {
        class = 'osu!'
    },
    workspace = '1',
}

wr {
    name = "email",
    match = {
        class = "org.mozilla.Thunderbird"
    },
    workspace = "4",
}

wr {
    name = "pinned-decor",
    match = {
        pin = true,
    },
    no_dim = true,
    rounding = 0,
    border_color = "rgb(ffff00)"
}

for _, name in pairs({
    "swiv",
    "nvim-float",
    "pick-reaction-image",
    "goker",
}) do
    wr {
        name = name,
        match = {
            class = name
        },
        float = true
    }
end

hl.on("hyprland.start", function()
    exec "hyprctl setcursor 'ArcStarry-cursors' 24"
    exec (os.getenv("HOME") .. "/.config/wlinit")
end)

hl.on("window.urgent", function(win)
    exec ('notify-send "alert" "' .. win.title:gsub('"', '') .. '"')
end)
