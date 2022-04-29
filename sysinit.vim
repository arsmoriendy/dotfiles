filetype plugin indent on
syntax on
set rnu nu
set noshowmode
set cursorline
set tgc
set sts=2
set sw=2
set noexpandtab
set list          " Display unprintable characters f12 - switches
set lcs=trail:•,tab:▷\ ,
set gcr=a:blinkon100,i:ver25
set updatetime=100
set signcolumn=yes

" emmet only html/css
let g:user_emmet_install_global = 0
autocmd FileType html,css EmmetInstall
" emmet trigger key
let g:user_emmet_leader_key='<TAB>'

call plug#begin('/etc/xdg/nvim/plugged')
Plug 'psliwka/vim-smoothie'
Plug 'preservim/nerdtree'
Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'preservim/nerdcommenter'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'ryanoasis/vim-devicons'
Plug 'airblade/vim-gitgutter'
Plug 'mattn/emmet-vim'
Plug 'prettier/vim-prettier', {
  \ 'do': 'npm install --frozen-lockfile --production',
  \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'svelte', 'yaml', 'html'] }
call plug#end()

let g:gruvbox_contrast_dark='hard'
let g:airline_powerline_fonts=1
autocmd VimEnter * hi Normal guibg=NONE
colo gruvbox
hi NonText guifg=#7c6f64 guibg=NONE
hi VertSplit guibg=NONE
hi signcolumn guibg=NONE
let g:prettier#config#use_tabs='false'

""" MAPS """
"auto close
fu IsNextKey(key)
  if getline(".")[col(".")-1] == a:key
    return 1
  en
endf
ino  { {}<LEFT>
ino <expr> } IsNextKey("}") ? '<RIGHT>' : "}"
ino ( ()<LEFT>
ino <expr> ) IsNextKey(")") ? '<RIGHT>' : ")"
ino [ []<LEFT>
ino <expr> ] IsNextKey("]") ? '<RIGHT>' : "]"
ino < <><LEFT>
ino <expr> > IsNextKey(">") ? '<RIGHT>' : ">"
ino <expr> ' IsNextKey("'") ? '<RIGHT>' : "''\<LEFT>"
ino <expr> " IsNextKey('"') ? '<RIGHT>' : '""<LEFT>'
ino <expr> ` IsNextKey("`") ? '<RIGHT>' : '``<LEFT>'
fu CheckWrap()
  let l:open = getline(".")[col(".")-2]
  let l:close = getline(".")[col(".")-1]
  if (l:open == "{" && l:close == "}")
    return 1
  elseif (l:open == "(" && l:close == ")")
    return 1
  elseif (l:open == "{" && l:close == "}")
    return 1
  elseif (l:open == "[" && l:close == "]")
    return 1
  elseif (l:open == "<" && l:close == ">")
    return 1
  elseif (l:open == "'" && l:close == "'")
    return 1
  elseif (l:open == '"' && l:close == '"')
    return 1
  elseif (l:open == "`" && l:close == "`")
    return 1
  en
endf
ino <expr> <BS> CheckWrap() ? '<RIGHT><BS><BS>' : '<BS>'
imap <C-H> <BS>
ino <expr> <CR> CheckWrap() ? '<CR><C-O>O' : '<CR>'
"toggle search highlight
no <C-f> :set hlsearch!<CR>
"exit
map <S-q> :qa!<CR>
map <C-s> :w<CR>
"delete
imap <C-l> <DEL>
"indent all lines
fu IndentAll()
  return "gg=G" . line(".") . "G"
endf
nno <expr> == IndentAll()
"nerdtree
map <C-1> :NERDTree<CR>
