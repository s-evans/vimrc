" TODO: Improve spreadsheet functionality
" TODO: Left/Right expression
" TODO: Improve custom mappings for consistency
" TODO: Add mappings for scope (ie. local recurse, path recurse, bufdo, windo, etc.)
" TODO: Add shellescape calls for string sanitization
" TODO: Add mappings for changing settings (ie. wrap, number)

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
set history=1000
set nowrap
colors evening
set title
set hidden

" Fix default grep settings
set grepprg=grep\ -n\ -H\ $*

" Fix slow completion
set complete-=i

" Fix stupid comment behavior
if has("autocmd") 
    autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
endif

" Cursor line settings
hi CursorLine cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white
set cul

" Cursor setting
set guicursor=n-v-c:block,o:hor50,i-ci:hor15,r-cr:hor30,sm:block

" Enable local .vimrc settings
set exrc
set secure

" Clang complete settings
set completeopt=menu,menuone

" Cscope settings
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

    nnoremap <leader>m :call ReplaceMathExpression()<CR>
endif

" Returns a list containing strings contained in the path variable
function! GetPathList() 
    let p = &path
    return split(p, ",")
endfunction

" Returns a space separated string of all elements in the path variable
function! GetPathString() 
    let plist = GetPathList()
    return join(plist, " ")
endfunction

" Executes a command string for each path element, replacing all occurances of %s with the path element string
function! ForEachPath(command)
    let plist = GetPathList()
    for p in plist 
        let newCommand = substitute(a:command, "\%s", p, "g")
        execute newCommand
    endfor
endfunction

" Clears out the quickfix list
function! ClearCw()
    call setqflist([]) 
    cclose
endfunction

" Closes out of all inactive buffers
function! DeleteInactiveBufs()
    " Get a list of all buffers in all tabs
    let tablist = []
    for i in range(tabpagenr('$'))
        call extend(tablist, tabpagebuflist(i + 1))
    endfor

    for i in range(1, bufnr('$'))
        if bufexists(i) && !getbufvar(i,"&mod") && index(tablist, i) == -1
            " bufno exists AND isn't modified AND isn't in the list of buffers open in windows and tabs
            silent exec 'bwipeout' i
        endif
    endfor
endfunction

" Clears up common sources of vim slowness
function! GarbageCollection()
    call ClearCw()
    call DeleteInactiveBufs()
endfunction

" Like bufdo, but returns to the original buffer when complete
function! BufDo(command)
    let currBuff=bufnr("%")
    execute 'bufdo! ' . a:command
    execute 'buffer ' . currBuff
endfunction

" Greps recursively from the current working directory
function! GrepRecurse(arg)
    silent execute "grep! -r ".a:arg
    cw
endfunction

" Greps in the current window
function! GrepCurrent(arg)
    silent execute "grep! ".a:arg." % "
    cw
endfunction

" Greps in all open windows
function! GrepBuffers(arg)
    call ClearCw()
    call BufDo("silent grepadd! ".a:arg." %")
    cw
endfunction

" Greps recursively for all directories in the path
function! GrepPath(arg)
    let plist = GetPathString()
    silent execute "grep! -r \"".a:arg."\" ".plist
    cw
endfunction

" Attempts to add a cscope database for each path element
function! CscopeAddPath()
    ForEachPath("cscope add %s %s")
    cs reset
endfunction

" Maps
let mapleader="\\"
nnoremap <leader>gpiW :call GrepPath('<cWORD>')<CR>
nnoremap <leader>gpiw :call GrepPath('<cword>')<CR>
nnoremap <leader>griW :call GrepRecurse('<cWORD>')<CR>
nnoremap <leader>griw :call GrepRecurse('<cword>')<CR>
nnoremap <leader>gciW :call GrepCurrent('<cWORD>')<CR>
nnoremap <leader>gciw :call GrepCurrent('<cword>')<CR>
nnoremap <leader>gbiW :call GrepBuffers('<cWORD>')<CR>
nnoremap <leader>gbiw :call GrepBuffers('<cword>')<CR>
nnoremap <leader>y :%!astyle --style=kr --break-blocks --pad-oper --pad-paren-in --align-pointer=type --indent-col1-comments<CR>
nnoremap <leader>c :%s/\/\/[ ]*\([^ ]\)/\/\/ \U\1/<CR>
nnoremap <leader>r :redraw!<CR>
nnoremap <leader>t :call GrepRecurse("TODO")<CR>
nnoremap <leader>l :source ~/.vimrc<CR>
nnoremap <leader>P "_diWP
nnoremap <leader>p "_diwP
nnoremap <leader>s :TScratch<CR>
nnoremap <leader>q :call GarbageCollection()<CR>
vnoremap <leader>p "_d"0P
inoremap <leader>t // TODO: 
inoremap jj <ESC>

