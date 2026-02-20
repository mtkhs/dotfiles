local wezterm = require 'wezterm'
local config = wezterm.config_builder()
local mux = wezterm.mux
local act = wezterm.action

----------------------------------------------------------------------------------
--
-- Functions
--
----------------------------------------------------------------------------------


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
    ----------------------------------------
    -- 起動時にウィンドウ最大化
    ----------------------------------------
    wezterm.on('gui-startup', function(cmd)
        local _, _, window = mux.spawn_window(cmd or {})
        window:gui_window():maximize()
    end)
elseif wezterm.target_triple == 'x86_64-apple-darwin' then
    config.default_prog = { 'zsh' }
end

config.window_close_confirmation = 'AlwaysPrompt'
config.window_decorations = 'INTEGRATED_BUTTONS'
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
config.hide_tab_bar_if_only_one_tab = false
-- config.show_new_tab_button_in_tab_bar = false
-- config.tab_max_width = 5

----------------------------------------------------------------------------------
--
-- Launcher Menu
--
----------------------------------------------------------------------------------
config.launch_menu = {
    {
        label = 'WSL Ubuntu',
        args = { },
        domain = { DomainName = 'WSL:Ubuntu' },
        cwd = '~'
    },
    {
        label = 'PowerShell 7',
        args = { 'pwsh.exe', '-NoLogo' },
        domain = { DomainName = 'local' },
    },
--    {
--        label = 'PowerShell',
--        args = { 'powershell.exe', '-NoLogo' },
--        domain = { DomainName = 'local' },
--    },
--    {
--        label = 'Command Prompt',
--        args = { 'cmd.exe' },
--        domain = { DomainName = 'local' },
--    },
--    {
--        label = 'Git Bash',
--        args = { 'C:\\Program Files\\Git\\bin\\bash.exe' },
--        domain = { DomainName = 'local' },
--    },
}

----------------------------------------------------------------------------------
--
-- Keys
--
----------------------------------------------------------------------------------
config.disable_default_key_bindings = true
config.keys = {
    ----------------------------------------
    -- WezTerm
    ----------------------------------------
    -- コマンドパレット
    { key = 'p', mods = 'SHIFT|CTRL', action = act.ActivateCommandPalette },
    -- ランチャーメニュー表示
    { key = 'l', mods = 'SHIFT|CTRL', action = act.ShowLauncher },
    -- 設定ファイルを開く
    { key = ',', mods = 'CTRL', action = wezterm.action_callback(function(window, pane)
        wezterm.open_with(wezterm.config_file)
    end)},

    ----------------------------------------
    -- タブ操作
    ----------------------------------------
    -- 新規タブ
    -- { key = 't', mods = 'SUPER', action = act.SpawnCommandInNewTab { domain = { DomainName = 'WSL:Ubuntu' }, cwd = '~' } },
    { key = 't', mods = 'SUPER', action = act.ShowLauncherArgs { flags = 'LAUNCH_MENU_ITEMS' }, },
    -- タブを切り替え
    { key = 'Tab', mods = 'SUPER', action = act.ActivateTabRelative(1) },
    { key = 'Tab', mods = 'SHIFT|SUPER', action = act.ActivateTabRelative(-1) },
    -- タブを閉じる
    { key = 'w', mods = 'SUPER', action = act.CloseCurrentTab{ confirm = true } },
    
    ----------------------------------------
    -- ペイン操作
    ----------------------------------------
    -- ペインを水平方向に開く
    { key = "^", mods = "SUPER", action = act.SplitVertical { domain = "CurrentPaneDomain", cwd = '~' } },
    -- ペインを縦方向に開く
    { key = "\\", mods = "SUPER", action = act.SplitHorizontal { domain = "CurrentPaneDomain", cwd = '~' } },
    -- ペインを閉じる
    { key = "w", mods = "SHIFT|CTRL", action = act.CloseCurrentPane { confirm = true } },
    -- ペインを切り替え
    { key = "q", mods = "SUPER", action = act.ActivatePaneDirection "Next" },
    { key = "q", mods = "SHIFT|SUPER", action = act.ActivatePaneDirection "Prev" },
    -- ペインサイズを変更
    { key = "h", mods = "SHIFT|SUPER", action = act.AdjustPaneSize { 'Left', 5 } },
    { key = "l", mods = "SHIFT|SUPER", action = act.AdjustPaneSize { 'Right', 5 } },
    { key = "k", mods = "SHIFT|SUPER", action = act.AdjustPaneSize { 'Up', 5 } },
    { key = "j", mods = "SHIFT|SUPER", action = act.AdjustPaneSize { 'Down', 5 } },
    { key = "LeftArrow", mods = "ALT", action = act.AdjustPaneSize { 'Left', 5 } },
    { key = "RightArrow", mods = "ALT", action = act.AdjustPaneSize { 'Right', 5 } },
    { key = "UpArrow", mods = "ALT", action = act.AdjustPaneSize { 'Up', 5 } },
    { key = "DownArrow", mods = "ALT", action = act.AdjustPaneSize { 'Down', 5 } },

    ----------------------------------------
    -- ターミナル
    ----------------------------------------
    -- Ctrl+Backspaceで単語削除
    { key = "Backspace", mods = "CTRL", action = act.SendKey { key = "w", mods = "CTRL" } },
    -- クリップボード貼り付け
    { key = 'Insert', mods = 'SHIFT', action = act.PasteFrom( 'Clipboard' ) },
    -- フォントサイズ
    -- { key = ';', mods = 'CTRL', action = act.IncreaseFontSize },
    -- { key = '-', mods = 'CTRL', action = act.DecreaseFontSize },
    -- { key = '0', mods = 'CTRL', action = act.ResetFontSize },
    {
        key = "F",
        mods = "CTRL|SHIFT",
        action = wezterm.action.Search({ CaseInSensitiveString = "" }),
    },
}

----------------------------------------------------------------------------------
--
-- Mouse
--
----------------------------------------------------------------------------------
config.mouse_bindings = {
    ----------------------------------------
    -- テキスト選択でコピー
    ----------------------------------------
    {
      event = { Up = { streak = 1, button = 'Left' } },
      mods = 'NONE',
      action = act.CopyTo( 'ClipboardAndPrimarySelection' ),
    },
    ----------------------------------------
    -- 右クリックでペースト
    ----------------------------------------
    {
      event = { Down = { streak = 1, button = 'Right' } },
      mods = 'NONE',
      action = act.PasteFrom( 'Clipboard' ),
    },
    ----------------------------------------
    -- Ctrl+ClickでURLオープン
    ----------------------------------------
    {
        event = { Up = { streak = 1, button = "Left" } },
        mods = "CTRL",
        action = act.OpenLinkAtMouseCursor,
    },
    -- 誤動作回避
    {
        event = { Down = { streak = 1, button = "Left" } },
        mods = "CTRL",
        action = act.Nop,
    },
}

----------------------------------------------------------------------------------
--
-- Plugins
--
----------------------------------------------------------------------------------

return config
