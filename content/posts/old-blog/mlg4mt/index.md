---
title: "使用树莓派3b+作为辅助开发体验"
date: "2021-08-30 21:18:15"
draft: false
---

# 配置
树莓派3B+的配置

- 4核1G
- CPU ARMv7 Processor
- 64G SD卡


# 常用软件

- neovim
- LXTerminal终端
- chrome浏览器
- 谷歌拼音输入法


# 常用语言

- golang
- c
- nodejs


# 外设

- 键盘鼠标： 雷柏 无线机械键盘加鼠标 150块左右
- 屏幕：一块ipad大小外接屏幕，400块左右


# 常用工作

- Golang UDP Server开发， 总体还算流畅。前提时不要加载太多的neovim插件，特别象coc-vim, go-vim等插件，安装过后让你卡的绝望。每次当我绝望之时，我就关闭了图形界面，回到终端继续干活。但是即使使用纯文本方式登录，运行vim还是很卡。
- 后来我在macbook pro上也用neovim开发，发现也是很卡。于是我就释然了，9千多的macbook都卡，300多的树莓派卡一点怎么了！
- 但是卡顿还是非常影响心情的，于是我就大量精简vim的插件。
- 我基本上就用两个插件，都是和状态栏有关的。其他十二个插件都给注释掉了

```
call plug#begin('~/.vim/plugged')

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'jiangmiao/auto-pairs'
"Plug 'yonchu/accelerated-smooth-scroll'
"Plug 'preservim/tagbar', { 'for': ['go', 'c']}
"Plug 'airblade/vim-gitgutter'
"Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries', 'for': 'go' }
"Plug 'dense-analysis/ale'
"Plug 'vim-scripts/matchit.zip'
"Plug 'pangloss/vim-javascript', {'for':'javascript'}
"Plug 'leafgarland/typescript-vim'
"Plug 'neoclide/coc.nvim', {'branch': 'release'}
"Plug 'jremmen/vim-ripgrep'
"Plug 'plasticboy/vim-markdown'
"Plug 'mzlogin/vim-markdown-toc'
call plug#end()


filetype plugin indent on

filetype plugin on
filetype indent on
set guicursor=
set history=1000
let g:netrw_banner=0
let g:ale_linters = {
\   'javascript': ['standard'],
\   'typescript': ['tsserver']
\}
let g:ale_fixers = {'javascript': ['standard']}
let g:ale_lint_on_save = 1
let g:ale_fix_on_save = 1
let g:ale_typescript_tsserver_executable='tsserver'
let g:airline#extensions#tabline#enabled = 1
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
let g:ale_open_list = 0
let g:vim_markdown_folding_disabled = 1
let g:vmt_cycle_list_item_markers = 1
let g:tagbar_sort = 0
" colorscheme codedark
" let g:airline_theme = 'codedark'
"
" buffer
let mapleader = ","
nnoremap <Leader>j :bp<CR>      " previous buffer
nnoremap <Leader>k :bn<CR>      " next buffer
nnoremap <Leader>n :bf<CR>      " previous buffer
nnoremap <Leader>m :bl<CR>      " next buffer
nnoremap <Leader>l :b#<CR>      " previous buffer
nnoremap <Leader>e :e<CR>      " open netrw
nnoremap <Leader>d :bd<CR>             " close buffer
nnoremap <Leader>g :!go fmt %<CR>             " go fmt current file
nnoremap <Leader>tm :%s/\s\+$//e<CR>             " trim space at endofline
nnoremap <Leader>a A
nnoremap <Leader>w :w<CR>
nnoremap <Leader>c :clo<CR>
nnoremap <Leader>/ :Rg<Space>
inoremap jj <ESC>
highlight CocErrorFloat ctermfg=White

let g:netrw_list_hide= '.*\.swp$'
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.?(git|hg|svn|node_modules)$',
  \ 'file': '\v\.(exe|so|dll|min.js)$',
  \ 'link': 'some_bad_symbolic_links',
  \ }

set autoread
" au CursorHold,CursorHoldI * :e
" au FocusGained,BufEnter * :e
set so=7
set ruler
set cmdheight=2

set hid
set backspace=eol,start,indent
set whichwrap+=<,>,h,l
set ignorecase
set smartcase
set hlsearch
set incsearch
set showmatch
set mat=2
syntax enable
set background=dark
set ffs=unix,dos,mac
"set ai "Auto indent
"set si "Smart indent
set wrap "Wrap lines
set cursorline
set tabstop=4
set shiftwidth=4
set expandtab
set background=dark
" colorscheme solarized
" let g:ackprg = 'rg --vimgrep --type-not sql --smart-case'
map ; :
autocmd FileType javascript setlocal ts=2 sts=2 shiftwidth=2

```

- 但是没有go-vim写golang还是不太方便的，特别是保存的时候格式化，但是也有方案, 执行vim的Ex命令，`：!go fmt %` 



## 视频

- 看视频是非常危险的行为，有可能需要强制关机重启。
