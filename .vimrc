" Pathogen, for easy git based vimrc management
runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()

" General settings
filetype on
filetype plugin on
filetype plugin indent on
syntax on
set autoindent
set expandtab
set ruler
set number
set shiftwidth=4
set softtabstop=4
set tabstop=4
set bs=2
set mouse=""
set wildmenu
set wildmode=list:longest,full
set history=500
set nowrap
colors evening

" Maps
nnoremap <C-K><C-G> :grep! "<C-R><C-W>" **<CR>:cw<CR>
nnoremap <C-K><C-Y> :%!astyle --style=kr<CR>
nnoremap <C-K><C-R> :redraw!<CR>
nnoremap <C-K><C-T> :grep! "TODO" **<CR><CR>:cw<CR>
nnoremap <C-K><C-L> :source ~/.vimrc<CR>
nnoremap <C-K><C-P> "_diwP
vnoremap <C-K><C-P> "_d"0P
inoremap <C-K><C-T> // TODO: 
inoremap jj <ESC>

" Fix slow completion
set complete-=i

" Fix stupid comment behavior
if has("autocmd") 
    autocmd FileType c,cpp,java setlocal comments-=:// comments+=f://
    autocmd FileType vim setlocal comments-=:\" comments+=f:\"
endif

" Cursor line settings
hi CursorLine cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white
set cul

" Enable local .vimrc settings
set exrc
set secure

" Clang complete settings
set completeopt=menu,menuone

" Cscope additional settings
if has("cscope")
    set nocscopeverbose
    set cscopequickfix=s-,c-,d-,i-,t-,e-,g-

    function! ScanAndReset()
        :silent !cscope -Rbq
        :cs reset
        :echo "Done!"
    endfunction

    function! ScanAndResetJava()
        :silent !find * -type f | grep "\.java$" > cscope.files
        :call ScanAndReset()
    endfunction

    if has("autocmd") 
        autocmd BufWritePre * nmap <C-\><C-\> :call ScanAndReset()<CR>
        autocmd Filetype java nmap <C-\><C-\> :call ScanAndResetJava()<CR>
    endif
endif

" Eclim settings
if has("autocmd") 
    autocmd Filetype java let g:EclimCompletionMethod = 'omnifunc'
endif 

" Mathematical functions
if has("python")
    function! EvalMathExpression(exp) 
        execute "py sys.argv = [\"".a:exp."\"]"
        py sys.argv[0] = eval(sys.argv[0])
        py vim.command("let out = \"" + str(sys.argv[0]) + "\"")
        return out
    endfunction

    function! ReplaceMathExpression() 
        let exp = expand("<cWORD>")
        let out = EvalMathExpression(exp)
        execute "normal ciW".out
    endfunction

    py from math import * 
    py import vim
    py import sys

    nnoremap <C-K><C-M> :call ReplaceMathExpression()<CR>
endif
