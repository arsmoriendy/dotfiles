filetype plugin indent on
syntax on
set rnu nu
set noshowmode "no show INSERT, VISUAL, NORMAL
set termguicolors
set softtabstop=2
set shiftwidth=2
set noexpandtab
set list          " Display unprintable characters f12 - switches
set listchars=trail:•,tab:│\ ,
set guicursor=i:ver100,a:blinkon100
set updatetime=100
set cursorline
set ignorecase smartcase
set tabline=%!MyTabLine()

function MyTabLine()
  let s = ''
  highlight TabLineSel guibg=#a89984 guifg=#3c3836
  highlight TabLineSelPL2 guibg=#3c3836 guifg=#a89984

  for i in range(tabpagenr('$'))
    let BufName = fnamemodify(bufname(tabpagebuflist(i + 1)[tabpagewinnr(i + 1) - 1]), ":t")
    let BufSymbol = WebDevIconsGetFileTypeSymbol(BufName)
    let TabLabel = BufSymbol . ' ' . BufName

    if i + 1 == tabpagenr()
      let s .= '%#TabLineSel#'
      if tabpagenr() == 1
	let s .= ' '
      else
	let s .= ' '
      endif
      let s .=  TabLabel.' %#TabLineSelPL2# '
    else
      let s .= '%#TabLine#' .  ' '.TabLabel.' '
    endif
  endfor

  return s
endfunction

"https://github.com/junegunn/vim-plug
call plug#begin('~/.config/nvim/plugged')
Plug 'preservim/nerdtree'
Plug 'lambdalisue/suda.vim'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'preservim/nerdcommenter'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'ryanoasis/vim-devicons'
Plug 'airblade/vim-gitgutter'
Plug 'mattn/emmet-vim'
Plug 'pangloss/vim-javascript'
Plug 'prettier/vim-prettier', {
      \ 'do': 'npm install --frozen-lockfile --production',
      \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'svelte', 'yaml', 'html'] }
Plug 'dag/vim-fish'
call plug#end()

" vim-javascript
autocmd FileType javascript call VimInitJS()
function VimInitJS()
  let g:javascript_plugin_jsdoc = 1
  let g:javascript_plugin_ngdoc = 1
endfunction
" emmet only html/css
let g:user_emmet_install_global = 0
let g:user_emmet_expandabbr_key = '<S-Tab>'
autocmd FileType html,css,javascript EmmetInstall
" gruvbox
let g:gruvbox_contrast_dark='hard'
let g:airline_powerline_fonts = 1
" prettier
let g:prettier#config#use_tabs='false'
let g:prettier#autoformat = 1
let g:prettier#autoformat_require_pragma = 0
let g:coc_global_extensions = ['coc-json', 'coc-tsserver', 'coc-css', 'coc-highlight']
autocmd CursorHold * silent call CocActionAsync('highlight')
"NERDTee
let g:NERDTreeShowHidden = 1
let g:NERDTreeQuitOnOpen = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeMinimalMenu = 1
let g:NERDTreeCascadeSingleChildDir = 0
let g:NERDTreeCascadeOpenSingleChildDir = 1
let g:NERDTreeMirror = 1
let g:NERDTreeAutoDeleteBuffer = 1
let g:NERDTreeGitStatusIndicatorMapCustom = {
      \ 'Modified'  :'*',
      \ 'Untracked' :'u',
      \ 'Dirty'     :'!',
      \ 'Ignored'   :'ᐞ',
      \ }
"suda.vim
let g:suda_smart_edit = 1

"==================== COLOR-SCHEME ===================="
colorscheme gruvbox
highlight Normal guibg=NONE
highlight NonText guifg=#7c6f64 guibg=NONE
highlight VertSplit guibg=NONE
highlight signcolumn guibg=NONE
highlight CursorLineSign guibg=#3c3836
" Gruvbox
highlight GruvboxRedSign guibg=NONE
highlight GruvboxGreenSign guibg=NONE
highlight GruvboxYellowSign guibg=NONE
highlight GruvboxBlueSign guibg=NONE
highlight GruvboxPurpleSign guibg=NONE
highlight GruvboxAquaSign guibg=NONE
highlight GruvboxOrangeSign guibg=NONE
" airline
let g:airline_theme_patch_func = 'AirlineThemePatch'
function! AirlineThemePatch(palette)
  for mode in keys(a:palette)
    if string(mode) =~# "'normal'\\|'visual'\\|'replace'\\|'insert'"
      let a:palette[mode].airline_a[0] = "#3c3836"
      let a:palette[mode].airline_z[0] = "#3c3836"
    endif
  endfor
endfunction

"==================== KEY-MAPS ===================="
"auto close
function IsNextKey(key)
  if getline(".")[col(".")-1] == a:key
    return 1
  endif
endfunction

inoremap  { {}<LEFT>
inoremap <expr> } IsNextKey("}") ? '<RIGHT>' : "}"
inoremap ( ()<LEFT>
inoremap <expr> ) IsNextKey(")") ? '<RIGHT>' : ")"
inoremap [ []<LEFT>
inoremap <expr> ] IsNextKey("]") ? '<RIGHT>' : "]"
inoremap < <><LEFT>
inoremap <expr> > IsNextKey(">") ? '<RIGHT>' : ">"
inoremap <expr> ' IsNextKey("'") ? '<RIGHT>' : "''\<LEFT>"
inoremap <expr> " IsNextKey('"') ? '<RIGHT>' : '""<LEFT>'
inoremap <expr> ` IsNextKey("`") ? '<RIGHT>' : '``<LEFT>'

function CheckWrap()
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
  endif
endfunction

inoremap <expr> <BS> CheckWrap() ? '<RIGHT><BS><BS>' : '<BS>'
imap <C-H> <BS>
inoremap <expr> <CR> CheckWrap() ? '<CR><C-O>O' : '<CR>'
"toggle search highlight
function ToHls()
  set hls!
  if (&hls)
    echohl DiffAdd | echo "Search highlight ON" | echohl None
  else
    echohl DiffDelete | echo "Search highlight OFF" | echohl None
  en
endfunction
noremap <expr> <C-f> ToHls()
"reload config
nmap <C-_> :so ~/.config/nvim/init.vim<CR>
"exit
nmap <S-q> :qa!<CR>
nmap <C-w><C-q> :q!<CR>
"save
map <C-s> :w<CR>
"delete
imap <C-l> <DEL>
"indent all lines
function IndentAll()
  return "gg=G" . line(".") . "G"
endfunction
nnoremap <expr> == IndentAll()
"nerdtree
nmap <silent> <Space> :NERDTreeToggle<CR>
"revert to save
map <C-M-u> :earlier 1f<CR>
map <C-M-r> :later 1f<CR>
"Coc
inoremap <silent><expr> <C-Space> coc#refresh()
inoremap <expr> <TAB> pumvisible() ? '<C-y>' : '<C-g>u<TAB>'
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
"navigate vim windows
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
"navigate tabs
nmap <silent> <TAB> :tabn<CR>
nmap <silent> <S-TAB> :tabp<CR>
