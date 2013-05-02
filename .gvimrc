colorscheme jellybeans

set guifont=Ricty\ Discord:h17    " フォント
"set antialias                " アンチエイリアシング

if has('gui_macvim')
	set transparency=15
else
	set transparency=224
	set guioptions-=T            " ツールバー削除
endif

" カーソル点滅無効化
set guicursor=a:blinkon0

" ウィンドウ
set sessionoptions+=resize " 行・列を設定する

set cmdheight=2            " コマンドラインの高さ
set previewheight=5        " プレビューウィンドウの高さ

set splitbelow             " 横分割したら新しいウィンドウは下に
set splitright             " 縦分割したら新しいウィンドウは右に
set showtabline=2          " タブを常に表示

