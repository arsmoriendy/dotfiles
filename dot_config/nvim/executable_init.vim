" +++ INIT.VIM +++  vanilla nvim options and commands

"-- OPTIONS --"
set relativenumber number
set noshowmode "no show INSERT, VISUAL, NORMAL
set termguicolors
"number of spaces in <TAB> while editing
set softtabstop=2
"number of spaces in <TAB> in autotab
set shiftwidth=2
"replace <TAB> with spaces during editing
set expandtab
set list          " Display unprintable characters f12 - switches
set listchars=trail:•
set updatetime=100
set cursorline
set ignorecase smartcase
"read file on change and apply to buffer
set autoread
set nowrap
set showtabline=1

"-- COMMANDS --"
" show help
cabbrev h help
" show help in tab instead
cabbrev th tab help
" packer
cabbrev pc PackerCompile
cabbrev ps PackerSync
cabbrev p PackerStatus
" twilight
cabbrev tw Twilight
" HIGHLIGHTS
highlight VertSplit guibg=None
highlight Pmenu guibg=None

"-- KEYMAPS --"
"reload config
nmap <F5> :source ~/.config/nvim/init.vim<CR>
"exit
nmap <S-q> :qa!<CR>
nmap <C-w><C-q> :q!<CR>
"save
map <C-s> :w<CR>
imap <C-s> <ESC>:w<CR>
"delete
imap <C-l> <DEL>
"indent all lines
function IndentAll()
  return "gg=G" . line(".") . "G"
endfunction
nnoremap <expr> == IndentAll()
"revert to save
map <C-M-u> :earlier 1f<CR>
imap <C-M-u> <ESC>:earlier 1f<CR>
map <C-M-r> :later 1f<CR>
imap <C-M-r> <ESC>:later 1f<CR>
"navigate vim windows
map <M-h> <C-w>h
map <M-j> <C-w>j
map <M-k> <C-w>k
map <M-l> <C-w>l
"navigate tabs
map <silent> <C-Tab> :tabnext<CR>
imap <silent> <C-Tab> <ESC>:tabnext<CR>
map <silent> <C-S-Tab> :tabprevious<CR>
imap <silent> <C-S-Tab> <ESC>:tabprevious<CR>
" diagnostics
nmap <silent> <Enter> :lua vim.diagnostic.open_float()<CR>
nmap <silent> <Tab> :lua vim.diagnostic.goto_next()<CR>
nmap <silent> <S-Tab> :lua vim.diagnostic.goto_prev()<CR>
" disable jumping
nmap <C-o> <Enter>

"-- LOAD LUA CONFIGS --"
source ~/.config/nvim/lua/init.lua
