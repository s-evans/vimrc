" TODO: Improve spreadsheet functionality
" TODO: Left/Right expression text object
" TODO: Improve custom mappings for consistency
" TODO: Add mappings for scope (ie. local recurse, path recurse, bufdo, windo, etc.)
" TODO: Add shellescape calls for string sanitization
" TODO: Maps for transforms (md5sum, base64, other csums)
" TODO: Function for cd dir, exec, cd -
" TODO: Fork changes? (textobj-between, cctree)

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

    function! CscopeRescan()
        " Special case for java; Get the list of java files;
        let ft = &filetype
        if ft == "java"
            silent !find * -type f | grep "\.java$" > cscope.files
        endif

        " Execute Cscope rescan
        silent !cscope -Rbqk
    endfunction

    function! CscopeRescanDir(dir)
        cd a:dir
        call CscopeRescan()
        cd -
    endfunction

    function! CscopeGetDbLines()
        redir =>cslist
        silent! cs show
        redir END
        return split(cslist, '\n')
    endfunction

    function! CscopeGetDbPaths()
        let dblines = CscopeGetDbLines()
        let paths = []

        for line in dblines
            " Split the line into space separated tokens
            let tok = split(line)

            " Check that we got something
            if empty(tok)
                continue
            endif

            " Check if the first element is a number
            if match(tok[0], "[0-9]") == -1
                continue
            endif

            " Get that path
            let tmppath = system("dirname ".tok[2])

            " Add to the path list
            call add(paths, tmppath)
        endfor

        return paths
    endfunction

    function! CscopeRescanAll()
        let paths = CscopeGetDbPaths()

        for pth in paths
            call CscopeRescanDir(pth)
        endfor

        cs reset
        redraw!
    endfunction

    function! CscopeRescanRecurse()
        call CscopeRescan()
        cs reset
        redraw!
    endfunction

    if has("autocmd") 
        nnoremap <C-\>r :call CscopeRescanRecurse()<CR>
        nnoremap <C-\>p :call CscopeRescanAll()<CR>
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

" Greps in all buffers 
function! GrepBuffers(arg)
    call ClearCw()
    call BufDo("silent grepadd! ".a:arg." %")
    cw
endfunction

" Greps in all windows
function! GrepWindows(arg) 
    call ClearCw()
    windo silent execute "grepadd! ".a:arg." %"
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

" Returns the list of buffers in string format
function! GetBufferList()
    redir =>buflist
    silent! ls
    redir END
    return buflist
endfunction

" Toggles the specified window
function! ToggleList(bufname, pfx)
    let buflist = GetBufferList()

    for bufnum in map(filter(split(buflist, '\n'), 'v:val =~ "'.a:bufname.'"'), 'str2nr(matchstr(v:val, "\\d\\+"))')
        if bufwinnr(bufnum) != -1
            exec(a:pfx.'close')
            return
        endif
    endfor

    if a:pfx == 'l' && len(getloclist(0)) == 0
        echohl ErrorMsg
        echo "Location List is Empty."
        return
    endif

    let winnr = winnr()
    exec(a:pfx.'open')

    if winnr() != winnr
        wincmd p
    endif
endfunction

" helper function to toggle hex mode
function! ToggleHex()
    " hex mode should be considered a read-only operation
    " save values for modified and read-only for restoration later,
    " and clear the read-only flag for now
    let l:modified=&mod
    let l:oldreadonly=&readonly
    let &readonly=0
    let l:oldmodifiable=&modifiable
    let &modifiable=1
    if !exists("b:editHex") || !b:editHex
        " save old options
        let b:oldft=&ft
        let b:oldbin=&bin
        " set new options
        setlocal binary " make sure it overrides any textwidth, etc.
        let &ft="xxd"
        " set status
        let b:editHex=1
        " switch to hex editor
        %!xxd
    else
        " restore old options
        let &ft=b:oldft
        if !b:oldbin
            setlocal nobinary
        endif
        " set status
        let b:editHex=0
        " return to normal editing
        %!xxd -r
    endif
    " restore values for modified and read only state
    let &mod=l:modified
    let &readonly=l:oldreadonly
    let &modifiable=l:oldmodifiable
endfunction

" Toggles diff on the current window
function! ToggleDiff()
    if &diff
        diffoff
    else
        diffthis
    endif
endfunction

" Define a default style that is overrideable by local project settings
if !exists('g:astyle')
    let g:astyle = "--style=kr --break-blocks --pad-oper --pad-paren-in --align-pointer=type --indent-col1-comments"
endif

" Calls astyle on the current window
function! RunAstyle()
    let lnum = line(".")
    execute "%!astyle " . g:astyle
    $delete
    execute "normal " . lnum . "G"
endfunction

" Create a scroll locked column (cannot be used with a locked row)
function! LockColumn()
    set scrollbind
    vsplit 
    vertical resize 20
    setlocal scrollopt=ver
    set scrollbind
    wincmd l
endfunction

" Create a scroll locked row (cannot be used with a locked column)
function! LockRow()
    set scrollbind
    split 
    resize 1
    setlocal scrollopt=hor
    set scrollbind
    wincmd j
endfunction

let mapleader="\\"

nnoremap <leader>gpiW :call GrepPath('<cWORD>')<CR>
nnoremap <leader>gpiw :call GrepPath('<cword>')<CR>

nnoremap <leader>griW :call GrepRecurse('<cWORD>')<CR>
nnoremap <leader>griw :call GrepRecurse('<cword>')<CR>

nnoremap <leader>gciW :call GrepCurrent('<cWORD>')<CR>
nnoremap <leader>gciw :call GrepCurrent('<cword>')<CR>

nnoremap <leader>gbiW :call GrepBuffers('<cWORD>')<CR>
nnoremap <leader>gbiw :call GrepBuffers('<cword>')<CR>

nnoremap <leader>gwiW :call GrepWindows('<cWORD>')<CR>
nnoremap <leader>gwiw :call GrepWindows('<cword>')<CR>

nnoremap <leader>wn :NERDTreeToggle<CR>
nnoremap <leader>wt :TlistToggle<CR>
nnoremap <leader>ws :TScratch<CR>
nnoremap <leader>wg :GundoToggle<CR>
nnoremap <leader>wx :call ToggleHex()<CR>
nnoremap <leader>wd :call ToggleDiff()<CR>
nnoremap <leader>wc :call ToggleList("Quickfix List", 'c')<CR>
nnoremap <leader>wo :call GrepRecurse("TODO")<CR>
nnoremap <leader>wa :AS<CR>

nnoremap <leader>wl :set number!<CR>
nnoremap <leader>ww :set wrap!<CR>
nnoremap <leader>wr :redraw!<CR>
" This breaks some things (NERDTree)
nnoremap <leader>wq :call GarbageCollection()<CR> 

nnoremap <leader>ta :call RunAstyle()<CR>
nnoremap <leader>tc :%s/\/\/[ ]*\([^ ]\)/\/\/ \U\1/<CR>
nnoremap <leader>tud :%!unix2dos -f<CR>
nnoremap <leader>tdu :%!dos2unix -f<CR>
nnoremap <leader>tmu :%!mac2unix -f<CR>
nnoremap <leader>tum :%!unix2mac -f<CR>

nnoremap <leader>lg :source ~/.vimrc<CR>
nnoremap <leader>ll :source ./.vimrc<CR>

nnoremap <leader>P "_diWP
nnoremap <leader>p "_diwP
vnoremap <leader>p "_d"0P

inoremap <leader>t // TODO: 
inoremap jj <ESC>

