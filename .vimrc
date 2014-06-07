" TODO: Improve spreadsheet functionality
" TODO: Left/Right expression text object
" TODO: Improve custom mappings for consistency
" TODO: Add shellescape calls for string sanitization
" TODO: Faster paste'ing replace'ing (textobjs)
" TODO: Re-open closed window
" TODO: Maps for transforms (md5sum, base64, other csums, c++filt, mathematical expressions)
" TODO: Function for cd dir, execute a:command_string, cd -
" TODO: Function for linenum, execute a:command_string, linenum G
" TODO: Fork changes? (textobj-between, cctree)
" TODO: Extraction function (clear out a register, input regex and scope, append matches into buffer)
" TODO: Look into operator pending maps
" TODO: Update comment update mapping to support more languages and comment styles

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
if has("cscope") && executable("cscope")
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
        silent! execute "cd " . a:dir
        call CscopeRescan()
        cd -
    endfunction

    function! CscopeGetDbLines()
        redir =>cslist
        silent! cscope show
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

    nnoremap <C-\>r :call CscopeRescanRecurse()<CR>
    nnoremap <C-\>p :call CscopeRescanAll()<CR>
endif

" Eclim settings
if has("autocmd") 
    autocmd Filetype java let g:EclimCompletionMethod = 'omnifunc'
endif 

" Mathematical functions
if has("python") && executable("python")
    function! EvalMathExpression(exp) 
        execute "py sys.argv = [\"" . a:exp . "\"]"
        python sys.argv[0] = eval(sys.argv[0])
        python vim.command("let out = \"" + str(sys.argv[0]) + "\"")
        return out
    endfunction

    function! ReplaceMathExpression() 
        let exp = expand("<cWORD>")
        let out = EvalMathExpression(exp)
        execute "normal ciW" . out
    endfunction

    nnoremap <leader>m :call ReplaceMathExpression()<CR>

    " Configure the python instance
    python << 
try:
    from math import * 
    import vim
    import sys
except ImportError:
    pass

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
            silent execute 'bwipeout' i
        endif
    endfor
endfunction

" Clears up common sources of vim slowness
" This breaks some things (NERDTree)
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
    silent execute "grep! -r " . a:arg
    cw
endfunction

" Greps in the current window
function! GrepCurrent(arg)
    silent execute "grep! " . a:arg . " % "
    cw
endfunction

" Greps in all buffers 
function! GrepBuffers(arg)
    call ClearCw()
    call BufDo("silent grepadd! " . a:arg . " %")
    cw
endfunction

" Greps in all windows
function! GrepWindows(arg) 
    call ClearCw()
    windo silent execute "grepadd! " . a:arg . " %"
    cw
endfunction

" Greps recursively for all directories in the path
function! GrepPath(arg)
    let plist = GetPathString()
    silent execute "grep! -r \"" . a:arg . "\" " . plist
    cw
endfunction

" Attempts to add a cscope database for each path element
function! CscopeAddPath()
    ForEachPath("cscope add %s %s")
    cscope reset
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

" Helper function to toggle hex mode
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
    let g:astyle = "--style=kr --break-blocks --pad-oper --unpad-paren --pad-paren-in --align-pointer=type --indent-col1-comments --add-brackets --pad-header"
endif

" Calls astyle on the current window
function! RunAstyle()
    let lnum = line(".")
    execute "%!astyle " . g:astyle
    $delete
    execute "normal " . lnum . "G"
endfunction

" Calls xmllint on the current window
function! RunXmlLint()
    let lnum = line(".")
    execute "%!xmllint --format -"
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

" Override astyle map for xml
if has("autocmd") 
    autocmd FileType xml nnoremap <buffer> <leader>ta :call RunXmlLint()<CR>
endif

function! OperatorWrapper(type) 
    let sel_save = &selection
    let &selection = "inclusive"
    let reg_save = @@

    if a:type ==# "v"
        silent execute "normal! `<v`>y"
    elseif a:type == 'line'
        silent execute "normal! '[V']y"
    elseif a:type == 'block'
        silent execute "normal! `[\<C-V>`]y"
    else
        silent execute "normal! `[v`]y"
    endif

    let command = substitute(g:OperatorWrapperCb, "\%s", shellescape(@@), "g")
    silent execute command

    let &selection = sel_save
    let @@ = reg_save
endfunction

let mapleader="\\"

" Grep operator mappings
nnoremap <leader>gp :set operatorfunc=OperatorWrapper<CR>:let g:OperatorWrapperCb="call GrepPath(%s)"<CR>g@
nnoremap <leader>gr :set operatorfunc=OperatorWrapper<CR>:let g:OperatorWrapperCb="call GrepRecurse(%s)"<CR>g@
nnoremap <leader>gc :set operatorfunc=OperatorWrapper<CR>:let g:OperatorWrapperCb="call GrepCurrent(%s)"<CR>g@
nnoremap <leader>gb :set operatorfunc=OperatorWrapper<CR>:let g:OperatorWrapperCb="call GrepBuffers(%s)"<CR>g@
nnoremap <leader>gw :set operatorfunc=OperatorWrapper<CR>:let g:OperatorWrapperCb="call GrepWindows(%s)"<CR>g@

vnoremap <leader>gp :<c-u>let g:OperatorWrapperCb="call GrepPath(%s)"<CR>:<c-u>call OperatorWrapper(visualmode())<CR>
vnoremap <leader>gr :<c-u>let g:OperatorWrapperCb="call GrepRecurse(%s)"<CR>:<c-u>call OperatorWrapper(visualmode())<CR>
vnoremap <leader>gc :<c-u>let g:OperatorWrapperCb="call GrepCurrent(%s)"<CR>:<c-u>call OperatorWrapper(visualmode())<CR>
vnoremap <leader>gb :<c-u>let g:OperatorWrapperCb="call GrepBuffers(%s)"<CR>:<c-u>call OperatorWrapper(visualmode())<CR>
vnoremap <leader>gw :<c-u>let g:OperatorWrapperCb="call GrepWindows(%s)"<CR>:<c-u>call OperatorWrapper(visualmode())<CR>

" Window mappings
nnoremap <leader>wn :NERDTreeToggle<CR>
nnoremap <leader>wt :TlistToggle<CR>
nnoremap <leader>ws :TScratch<CR>
nnoremap <leader>wg :GundoToggle<CR>
nnoremap <leader>wx :call ToggleHex()<CR>
nnoremap <leader>wd :call ToggleDiff()<CR>
nnoremap <leader>wc :call ToggleList("Quickfix List", 'c')<CR>
nnoremap <leader>wo :call GrepRecurse("TODO")<CR>
nnoremap <leader>wa :AS<CR>
nnoremap <leader>wfn :call LockRow()<CR>
nnoremap <leader>wfv :call LockColumn()<CR>
nnoremap <leader>wl :set number!<CR>
nnoremap <leader>ww :set wrap!<CR>
nnoremap <leader>wr :redraw!<CR>
nnoremap <leader>wq :call GarbageCollection()<CR> 

" Text transform mappings
nnoremap <leader>ta :call RunAstyle()<CR>
nnoremap <leader>tc :%s/\/\/[ ]*\([^ ]\)/\/\/ \U\1/<CR>
nnoremap <leader>tt :%!column -t<CR>
nnoremap <leader>ts :%!column -s, -t<CR>
nnoremap <leader>tud :%!unix2dos -f<CR>
nnoremap <leader>tdu :%!dos2unix -f<CR>
nnoremap <leader>tmu :%!mac2unix -f<CR>
nnoremap <leader>tum :%!unix2mac -f<CR>

" Project mappings
nnoremap <leader>pm :make<CR>

" vimrc reload mappings
nnoremap <leader>lg :source ~/.vimrc<CR>
nnoremap <leader>ll :source ./.vimrc<CR>

inoremap <leader>t // TODO: 
inoremap jj <ESC>

