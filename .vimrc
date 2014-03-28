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
inoremap jj <ESC>
colors evening

" Cursor Line
hi CursorLine cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white
set cul

" Enable Local .vimrc
set exrc
set secure

" Clang Complete
set conceallevel=2
set concealcursor=vin
let g:clang_snippets=1
let g:clang_conceal_snippets=1
let g:clang_snippets_engine='clang_complete'
set completeopt=menu,menuone
set pumheight=20

if has("cscope")
    source ~/.vim/plugin/cscope_maps.vim
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

source ~/.vim/plugin/taglist.vim

if has("autocmd") 
    autocmd Filetype java let g:EclimCompletionMethod = 'omnifunc'
endif 
