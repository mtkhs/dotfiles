
--
-- encoding
--
vim.scriptencoding = 'utf-8'
vim.opt.encoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'

--
-- interface
--
vim.opt.title = true
vim.opt.termguicolors = true -- 24bitカラーを有効に
vim.opt.winblend = 0 -- ウィンドウの不透明度
vim.opt.pumblend = 0 -- ポップアップメニューの不透明度
vim.opt.showtabline = 2 -- タブラインを表示
vim.opt.wildmenu = true -- 補完候補をメニューで表示する
vim.opt.wildmode = {"longest", "full"} -- 補完モードを設定する

--
-- os
--
vim.opt.clipboard:append('unnamedplus,unnamed') -- OSのクリップボードを共有
vim.opt.autochdir = true  -- カレントディレクトリを自動変更
vim.opt.backup = false  -- バックアップファイルを作成しない
vim.opt.swapfile = false  -- スワップファイルを生成しない

--
-- view
--
vim.opt.number = true -- 行番号を表示する
vim.opt.relativenumber = true -- 行番号を相対表示する
vim.opt.signcolumn = 'yes' -- 行番号表示に余白を追加
vim.opt.cursorline = false -- カーソル行をハイライトする
vim.opt.cursorcolumn = false -- カーソル列をハイライトする
vim.opt.showmatch = true -- 対応する括弧を表示する
-- indent
vim.opt.autoindent = true -- 自動インデントを有効に
vim.opt.smartindent = true -- インデントをスマートに
vim.opt.shiftwidth = 4 -- シフト幅を2に
vim.opt.tabstop = 4 -- タブ幅を2に
vim.opt.expandtab = true -- タブ文字をスペース文字に
-- list
vim.opt.list = true -- 特殊文字を表示する
vim.opt.listchars = {tab='>-', trail='-', eol='↲', extends='»', precedes='«', nbsp='%'} -- 特殊文字の種類と表示方法を設定する
-- vim.opt.ambiwidth = 'double'

--
-- search
--
vim.opt.incsearch = true -- インクリメンタルサーチを有効に
vim.opt.ignorecase = true -- 大文字小文字を区別しない
vim.opt.smartcase = true -- 大文字を含んで検索したときは区別する
vim.opt.hlsearch = true -- 検索語をハイライトする
vim.opt.matchtime = 1 -- 入力文字がマッチするまでの時間
vim.opt.inccommand = 'split' -- インクリメンタルサーチ結果を分割表示

--
-- edit
--
vim.opt.backspace = 'start,eol,indent' -- バックスペースで削除できる文字
vim.opt.virtualedit = 'onemore' -- 行末までカーソルを移動可能に
vim.opt.scrolloff = 10 -- スクロール時の上下余白
-- wrap lines
vim.opt.wrap = true  -- 行を折り返す
vim.opt.showbreak = '↪' -- 折り返し文字
vim.opt.whichwrap = 'b,s,h,l,<,>,[,],~'
-- completion
vim.opt.completeopt = 'fuzzy,menu,menuone,noselect' -- 補完時の挙動

--
-- performance
--
vim.opt.lazyredraw = true -- スクロール時の再描画の頻度を減らす

