local wezterm = require 'wezterm'
local config = wezterm.config_builder()
local mux = wezterm.mux
local act = wezterm.action

----------------------------------------------------------------------------------
--
-- Basic
--
----------------------------------------------------------------------------------
config.automatically_reload_config = true
config.window_close_confirmation = 'NeverPrompt'
config.default_cursor_style = 'BlinkingBar'
config.use_ime = true

----------------------------------------------------------------------------------
--
-- Font
--
----------------------------------------------------------------------------------
config.font = wezterm.font_with_fallback({
    { family = 'Utatane' },
    { family = 'HackGen Console NF', assume_emoji_presentation = true },
    { family = 'Segoe UI Emoji', assume_emoji_presentation = true },
    { family = 'Noto Color Emoji', assume_emoji_presentation = true },
})
config.font_size = 13.0

----------------------------------------------------------------------------------
--
-- Window
--
----------------------------------------------------------------------------------
if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
    config.default_domain = 'WSL:Ubuntu'
    --
    -- 起動時にウィンドウ最大化
    --
    wezterm.on('gui-startup', function(cmd)
        local _, _, window = mux.spawn_window(cmd or {})
        window:gui_window():maximize()
    end)
elseif wezterm.target_triple == 'x86_64-apple-darwin' then
    config.default_prog = { 'zsh' }
end

config.window_decorations = 'RESIZE|INTEGRATED_BUTTONS'
config.window_background_opacity = 0.80
config.macos_window_background_blur = 10
config.window_background_gradient = {
    colors = { '#000000' },
}
config.window_frame = {
    font = wezterm.font('Roboto'),
    font_size = 10.0,
    inactive_titlebar_bg = 'none',
    active_titlebar_bg = 'none',
}
config.enable_scroll_bar = true
config.colors = {
    tab_bar = { inactive_tab_edge = 'none' },
}
local color_scheme = 'Tokyo Night Storm (Gogh)'
config.color_scheme = color_scheme

----------------------------------------------------------------------------------
--
-- Tab
--
----------------------------------------------------------------------------------
config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
-- config.show_new_tab_button_in_tab_bar = false
-- config.tab_max_width = 5

----------------------------------------------------------------------------------
--
-- Keys
--
----------------------------------------------------------------------------------
config.disable_default_key_bindings = true
config.keys = {
    --
    -- タブ操作
    --
    {
        key = 't',
        mods = 'SUPER',
        action = act.SpawnCommandInNewTab {
            domain = { DomainName = 'WSL:Ubuntu' },
            cwd    = '~',
        },
    },
    {
        key = 'w',
        mods = 'SUPER',
        action = act.CloseCurrentTab { confirm = true },
    },
    {
        key = 'Tab',
        mods = 'SUPER',
        action = act.ActivateTabRelative(1)
    },
    {
        key = 'Tab',
        mods = 'SHIFT|SUPER',
        action = act.ActivateTabRelative(-1)
    },
    --
    -- Ctrl+Backspaceで単語削除
    --
    {
        key = "Backspace",
        mods = "CTRL",
        action = act.SendKey { key = "w", mods = "CTRL" },
    },
    { key = 'p', mods = 'SUPER', action = act.ActivateCommandPalette },
    { key = ';', mods = 'CTRL', action = act.IncreaseFontSize },
    { key = '-', mods = 'CTRL', action = act.DecreaseFontSize },
    { key = '0', mods = 'CTRL', action = act.ResetFontSize },
    { key = 'Insert', mods = 'SHIFT', action = act.PasteFrom( 'Clipboard' ) },
}

----------------------------------------------------------------------------------
--
-- Mouse
--
----------------------------------------------------------------------------------
config.mouse_bindings = {
    --
    -- テキスト選択でコピー
    --
    {
      event = { Up = { streak = 1, button = 'Left' } },
      mods = 'NONE',
      action = act.CopyTo( 'ClipboardAndPrimarySelection' ),
    },
    --
    -- 右クリックでペースト
    --
    {
      event = { Down = { streak = 1, button = 'Right' } },
      mods = 'NONE',
      action = act.PasteFrom( 'Clipboard' ),
    },
}

return config
