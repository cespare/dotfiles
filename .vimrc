syntax on
filetype plugin indent on

"
set hidden "This allows vim to put buffers in the bg without saving, and then allows undoes when you fg them again.
set history=1000 "Longer history
set number
set hlsearch
set autoindent
set smartindent
set expandtab
set wildmenu
set wildmode=list:longest
set scrolloff=3 " This keeps three lines of context when scrolling
set title
set expandtab
set smarttab
set ts=2
set sw=2
set sts=2
set laststatus=2
set statusline=%<%F%h%m%r%h%w%y\ %{&ff}\ %{strftime(\"%c\",getftime(expand(\"%:p\")))}%=\ lin:%l\,%L\ col:%c%V\ pos:%o\ ascii:%b\ %P
set ignorecase
set smartcase
set undofile
set backspace=indent,eol,start
set linespace=3

let mapleader = ","

" The following two lines are for highlighting lines which are too long
":au BufWinEnter *c,*.cpp,*.h,*.py let w:m1=matchadd('Search', '\%<101v.\%>97v', -1)
":au BufWinEnter *c,*.cpp,*.h,*.py,*.rb,*.mxml,*.as let w:m2=matchadd('ErrorMsg', '\%>110v.\+', -1)


" Mappings:
map <F6> :b#<CR>
map <C-n> :noh<CR>
map <C-Space> <C-x><C-o>

" Taglist stuff
nmap ,tu :!(ctags *.[ch])&<CR><CR>
map ,tl :TlistToggle<CR>
let Tlist_Exit_OnlyWindow = 1


" Colorscheme bullshittery:
set t_Co=16
set background=dark
colors zenburn

" Random commandline shortcuts
"
" latex build + evince ps view
" This one is weird...what is with the :t:r.tex?
"nmap ,tex :!(texbuildps.py %:t:r.tex)<CR><CR>
nmap ,tex :!(texbuildps.py %)<CR><CR>

" Specify filetypes
au BufNewFile,BufRead *.i set filetype=swig

" For pydiction:
let g:pydiction_location='~/.vim/pydiction-1.2/complete-dict'

" Gundo settings
nnoremap <F5> :GundoToggle<CR>

" NERDTree settings
let g:NERDTreeChDirMode=2
let g:NERDChristmasTree=1

" Stupid NERDCommenter warning
let NERDShutUp=1

" Better close functionality
nmap ,fc :call CleanClose(1)<CR>
nmap ,fq :call CleanClose(0)<CR>

function! CleanClose(tosave)
  if (a:tosave == 1)
    w!
  endif
let todelbufNr = bufnr("%")
let newbufNr = bufnr("#")
if ((newbufNr != -1) && (newbufNr != todelbufNr) && buflisted(newbufNr))
    exe "b".newbufNr
else
    bnext
endif

if (bufnr("%") == todelbufNr)
    new
endif
exe "bd".todelbufNr
endfunction

" Audio bell == annoying
set vb t_vb=

" More ruby settings
let ruby_space_settings = 1
highlight ExtraWhitespace ctermbg=green guibg=green
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" Make it easier to move around through blocks of text:
noremap <C-J> gj
noremap <C-k> gk
noremap U 30k
noremap D 30j

" Go specific settings
augroup golang
  au!
  au FileType go set noexpandtab
augroup END

" Pathogen == teh awesomes
call pathogen#runtime_append_all_bundles()

" Ack >> grep
nnoremap <leader>a :Ack

" A command to delete all trailing whitespace from a file.
command DeleteTrailingWhitespace %s:\(\S*\)\s\+$:\1:
