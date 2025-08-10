-------------------------------------------------------------------------------
--
-- Neovim起動時にロゴをﾋｭﾝﾋｭﾝﾋｭﾝﾋｭﾝﾋｭﾝ!!ﾌﾜﾜ~~ﾝ!!する
-- https://zenn.dev/vim_jp/articles/de942e6414685e
-- 
-------------------------------------------------------------------------------
---
-- augroup for this config file
local augroup = vim.api.nvim_create_augroup('startup-logo', {})

-- wrapper function to use internal augroup
local function create_autocmd(event, opts)
  vim.api.nvim_create_autocmd(
    event,
    vim.tbl_extend('force', {
      group = augroup,
    }, opts)
  )
end

local logo = [[
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
━━━━━━━━ ▄▄    ▄ ▄▄▄▄▄▄▄ ▄▄▄▄▄▄▄ ▄▄   ▄▄ ▄▄ ▄▄   ▄▄ ━━━━━━━━
━━━━━━━━█  █  █ █       █       █  █ █  █  █  █▄█  █━━━━━━━━
━━━━━━━━█   █▄█ █    ▄▄▄█   ▄   █  █▄█  █  █       █━━━━━━━━
━━━━━━━━█       █   █▄▄▄█  █ █  █       █  █       █━━━━━━━━
━━━━━━━━█  ▄    █    ▄▄▄█  █▄█  █       █  █       █━━━━━━━━
━━━━━━━━█ █ █   █   █▄▄▄█       ██     ██  █ ██▄██ █━━━━━━━━
━━━━━━━━█▄█  █▄▄█▄▄▄▄▄▄▄█▄▄▄▄▄▄▄█ █▄▄▄█ █▄▄█▄█   █▄█━━━━━━━━
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
]]

local function display_logo()
  local buf = vim.api.nvim_create_buf(false, true)
  -- local width = math.floor(vim.o.columns * 0.8)
  -- local height = math.floor(vim.o.lines * 0.8)
  local logo_lines = vim.split(vim.trim(logo), '\n')
  local line_widths = vim.tbl_map(function(line)
    return vim.fn.strdisplaywidth(line)
  end, logo_lines)
  local width = math.max(unpack(line_widths))
  local height = #logo_lines + 1
  --local row = 2
  local row = vim.o.lines / 10 - 4
  local col = math.floor((vim.o.columns - width) / 2)

  local focusable = false
  local winopts = {
    style = 'minimal',
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    border = 'none',
    focusable = focusable,
    noautocmd = true,
  }

  local win = vim.api.nvim_open_win(buf, focusable, winopts)
  vim.api.nvim_set_option_value('ambiwidth', 'single', { scope = 'local'})
  vim.api.nvim_set_option_value('winblend', 100, { scope = 'local', win = win })
  -- vim.api.nvim_set_option_value('winblend', 100, { win = win })
  -- vim.api.nvim_set_option_value('bufhidden', 'wipe', { scope = 'local', buf = buf })
  vim.api.nvim_set_option_value('bufhidden', 'wipe', { buf = buf })

  local subcommands = {
    'expand --movement-speed 0.8',
    'middleout --center-movement-speed 0.8 --full-movement-speed 0.2',
    'slide --merge --movement-speed 0.8',
    'beams --beam-delay 5 --beam-row-speed-range 20-60 --beam-column-speed-range 8-12',
    'sweep',
  }
  -- random pick subcommand
  math.randomseed(os.time())
  -- local subcommand = subcommands[3]
  local subcommand = subcommands[math.random(#subcommands)]
  local cmd = {
    'sh',
    '-c',
    -- 'echo -e '
    'echo '
      .. vim.fn.shellescape(vim.trim(logo))
      .. ' | tte --anchor-canvas s '
      .. subcommand
      .. ' --final-gradient-direction diagonal',
  }
  vim.api.nvim_buf_call(buf, function()
    vim.fn.jobstart(cmd, {
      term = true,
      on_exit = function() end,
    })
  end)
  return { buf = buf, win = win }
end

vim.api.nvim_create_autocmd('User', {
  group = augroup,
  pattern = 'MiniStarterOpened',
  callback = function()
    -- ロゴを描画
    local logo_info = display_logo(logo)
    -- 現在のバッファ（スタート画面）を抜けたときにロゴのウィンドウも閉じる
    -- bufhidden=wipeを設定しているのでバッファも自動で破棄される
    local buf = vim.api.nvim_get_current_buf()
    vim.api.nvim_create_autocmd('BufLeave', {
      group = augroup,
      once = true,
      buffer = buf,
      callback = function()
        vim.api.nvim_win_close(logo_info.win, true)
      end,
      desc = 'Close logo'
    })
  end,
  desc = 'Display logo when starter opened'
})

