filetype plugin indent on
syntax on
set rnu nu
set noshowmode "no show INSERT, VISUAL, NORMAL
set tgc
set sts=2 "fake tab
set sw=2
set noexpandtab
set list          " Display unprintable characters f12 - switches
set lcs=trail:•,tab:▷\ ,
set gcr=a:blinkon100,i:ver25
set updatetime=100
set signcolumn=yes

call plug#begin('/etc/xdg/nvim/plugged')
Plug 'psliwka/vim-smoothie'
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'preservim/nerdcommenter'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'ryanoasis/vim-devicons'
Plug 'airblade/vim-gitgutter'
Plug 'mattn/emmet-vim'
Plug 'prettier/vim-prettier', {
      \ 'do': 'npm install --frozen-lockfile --production',
      \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'svelte', 'yaml', 'html'] }
call plug#end()

" emmet only html/css
let g:user_emmet_install_global = 0
autocmd FileType html,css,javascript EmmetInstall
" emmet trigger key
let g:user_emmet_leader_key='<C-z>'
let g:gruvbox_contrast_dark='hard'
let g:airline_powerline_fonts=1
let g:prettier#config#use_tabs='false'
let g:coc_global_extensions = ['coc-json', 'coc-tsserver', 'coc-css', 'coc-highlight']
autocmd CursorHold * silent call CocActionAsync('highlight')
let g:NERDTreeShowHidden = 1
let g:NERDTreeGitStatusIndicatorMapCustom = {
                \ 'Modified'  :'*',
                \ 'Untracked' :'⬤',
                \ 'Dirty'     :'!',
                \ 'Ignored'   :'ᐞ',
                \ }

""" COLORSCHEME """
colo gruvbox
autocmd VimEnter *  hi Normal guibg=NONE
hi NonText guifg=#7c6f64 guibg=NONE
hi VertSplit guibg=NONE
hi signcolumn guibg=NONE
hi CursorLineNr guibg=NONE
" Gruvbox
hi GruvboxRedSign guibg=NONE
hi GruvboxGreenSign guibg=NONE
hi GruvboxYellowSign guibg=NONE
hi GruvboxBlueSign guibg=NONE
hi GruvboxPurpleSign guibg=NONE
hi GruvboxAquaSign guibg=NONE
hi GruvboxOrangeSign guibg=NONE
" gitgutter
hi GitGutterAdd guibg=NONE
hi GitGutterChange guibg=NONE
hi GitGutterDelete guibg=NONE
hi GitGutterChangeDelete guibg=NONE

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
fu ToHls()
  set hls!
  if (&hls)
    echohl DiffAdd | echo "Search highlight ON" | echohl None
  else
    echohl DiffDelete | echo "Search highlight OFF" | echohl None
  en
endf
no <expr> <C-f> ToHls()
"reload config
nmap <C-_> :so /etc/xdg/nvim/sysinit.vim<CR>
"exit
nmap <S-q> :qa!<CR>
nmap <C-w>q :q!<CR>
map <C-s> :w<CR>
"delete
imap <C-l> <DEL>
"indent all lines
fu IndentAll()
  return "gg=G" . line(".") . "G"
endf
nno <expr> == IndentAll()
"nerdtree
nmap <silent> <Space> :NERDTreeToggle<CR>
"revert to save
map <C-M-u> :earlier 1f<CR>
map <C-M-r> :later 1f<CR>
"Coc
ino <silent><expr> <C-Space> coc#refresh()
ino <expr> <TAB> pumvisible() ? '<C-y>' : '<C-g>u<TAB>'
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
"navigate vim windows
nno <C-h> <C-w>h
nno <C-j> <C-w>j
nno <C-k> <C-w>k
nno <C-l> <C-w>l
