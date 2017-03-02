"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" snd
" @since 05/31/13
" @updated 07/27/16
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

filetype plugin indent on " load filetype plugins
filetype on " autodetect filetype

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" universal settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set rtp+=/usr/bin/vim/ " ensure current vim version is included
set nocompatible " disable vi compatability mode
set ttyfast " fast redrawing in full terminals w/no scrollbar
set clipboard=unnamed,unnamedplus " allow copying between sessions with "+yy
set wrap
set hidden " hide buffers instead of closing with :on[ly]
set relativenumber "(set rnu) relative #ing for quick movement
set shortmess=a " smart shorten errs
set mouses=a:beam " i-beams (a = everywhere/all)
set guicursor=a:beam
set guioptions+=a " copy visual mode selections to clipboard
set encoding=utf-8
set termencoding=utf-8
set fileencoding=utf-8
set fileformats=unix,mac,dos " support in order
set fileformat=unix " set default file format
set backspace=indent,eol,start " fix backspace
set report=0 " always report lines changed
set mouse=a " always enable mouse
set history=4096
set ignorecase " ignore case (search)
set smartcase " caSe sEnSitive in a word (search)
set showcmd " show command bottom right-hand
set hlsearch " highlight search matches
set incsearch " highlight matches as you type search
set number " show line numbers
set textwidth=0
set wildmode=longest,list,full "autocomplete names
set wildmenu "allow menu of further options on autocomplete fail
set showmatch " highlight matching ( )
set novisualbell  " no blinking
set noerrorbells  " no sound
set nolist " show unprintable chars
set ruler " show current pos on bottom
set scrolloff=10 " lines to scroll
set cmdheight=1 " command bar should be 1 line only
set title
set number
set autochdir " autoset current directory to PWD

" backup settings:
set undofile " persistent undos after file closure
set undodir=~/.vim/undo
set undolevels=4096
set undoreload=65536
set backup
set backupdir=~/.vim/bak
set directory=~/.vim/tmp
set viminfo='1024,f1

" c settings:
set autoindent
set cindent
set cinoptions=:s,ps,ts,cs
set cinwords=if,else,while,do,for,switch,case
set nocp

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" color settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" set term var correctly for GNU screen
if match($TERM, "screen-256color")!=-1
  set term=xterm-256color
else
  if match($TERM, "screen")!=-1
    set term=xterm
  endif
endif

set t_Co=256 " use 256 colors
"set ts=4 sw=4 et " may resolve some color issues
set background=dark " color theme tweaks

colo inkpot " inkpot tir_black blackbeauty ansiblows midnight vividchalk
syntax on " use color

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" custom configurations
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" allow tabs in expected file types
let curfile = expand("%:t")
if curfile =~ "*.py" || curfile =~ "/etc/fstab/" || curfile =~ "Makefile" || curfile =~ "makefile" || curfile =~ ".*\.mk"
  set noexpandtab
else
  set tabstop=2
  set shiftwidth=2
  set softtabstop=2
  set expandtab
  set smarttab
endif

" latex tweaks
set grepprg=grep\ -nH\ $* 
let g:tex_flavor='latex'
let g:tex_comment_nospell=1
let g:netrw_silent = 1 " kill annoying error msgs
let g:yankring_history_dir="~/.vim"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" highlight the current line in the active window (19=dark blue):
hi CursorLine cterm=NONE ctermfg=white ctermbg=19 ctermfg=NONE guibg=19 guifg=NONE
augroup CursorLine
  au!
  au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  au WinLeave * setlocal nocursorline
augroup END

" always use i-beam (if available in emulator)
if has("autocmd")
  au InsertEnter * silent execute "!gconftool-2 --type string --set /apps/gnome-terminal/profiles/Default/cursor_shape ibeam"
  au InsertLeave * silent execute "!gconftool-2 --type string --set /apps/gnome-terminal/profiles/Default/cursor_shape ibeam"
  au VimLeave * silent execute "!gconftool-2 --type string --set /apps/gnome-terminal/profiles/Default/cursor_shape ibeam"
endif

" reopen files at same position as last time
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
        \| exe "normal! g'\"" | endif
endif

" function to toggle relative numbering
function! RNUToggle()
  if (&relativenumber == 1)
    set norelativenumber
  else
    set relativenumber
  endif
endfunc

" ensure proper state of line numbers on context switches
autocmd InsertEnter * silent :call RNUToggle()
autocmd InsertLeave * silent :call RNUToggle()
autocmd FocusLost * silent :call RNUToggle()
autocmd FocusGained * silent :call RNUToggle()
autocmd WinEnter * silent :call RNUToggle()
autocmd WinLeave * silent :call RNUToggle()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" key remappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" toggle relative numbers
nnoremap <silent> <C-n> :call RNUToggle()<CR>

" let space be 'single insert'
noremap <silent> <space> :exe "normal i".nr2char(getchar())<CR>

" ctrl+s = save all open; enter command mode
noremap <silent> <C-s> :wa<CR>
inoremap <silent> <C-s> <C-c>:wa<CR>
vnoremap <silent> <C-s> <C-c>:wa<CR>

" tab shortcuts (C-S-tab = Ctrl+Shift+Tab)
nnoremap <C-S-tab>  :tabprevious<CR>
nnoremap <C-tab>    :tabnext<CR>
nnoremap <C-t>      :tabnew<CR>
nnoremap <C-Delete> :tabclose<CR>
inoremap <C-S-tab>  <Esc>:tabprevious<CR>i
inoremap <C-tab>    <Esc>:tabnext<CR>i
inoremap <C-t>      <Esc>:tabnew<CR>

" move to next error ], prev [, list with l
nnoremap <silent> ] :lnext<CR>
nnoremap <silent> [ :lprev<CR>

" allow '.' to repeat last command on every line of selection in visual mode
vnoremap . :normal .<CR>

" F2 toggles paste mode for direct unmodified pasting and shows the status
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode

" clear screen when exiting vim manually b/c tmux/screen/ssh/etc.
au VimLeave * :!clear
