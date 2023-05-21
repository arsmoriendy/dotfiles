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
set timeout!

"-- VARIABLES --"
let mapleader = "\\"

"-- COMMANDS --"
" show help
cabbrev h help
" show help in tab instead
cabbrev th tab help

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
" "navigate vim windows
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
" close vim windows
map <C-q> <C-w>q
" diagnostics
nmap <silent> <Enter> :lua vim.diagnostic.open_float()<CR>
nmap <silent> <Tab> :lua vim.diagnostic.goto_next()<CR>
nmap <silent> <S-Tab> :lua vim.diagnostic.goto_prev()<CR>
" rename variable on cursor with lsp support
nmap <Leader>r :lua vim.lsp.buf.rename()<CR>

"-- LOAD LUA CONFIGS --"
exec "source " .. stdpath("config") .. "/lua/init.lua"

