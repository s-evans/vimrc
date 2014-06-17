" TODO: Faster paste'ing replace'ing (textobjs)
" TODO: Update filtering maps to operate on sub-line motions
" TODO: Left/Right expression text object
" TODO: Improve spreadsheet functionality
" TODO: Function for cd dir, execute a:command_string, cd -
" TODO: Function for linenum, execute a:command_string, linenum G
" TODO: Fork changes? (textobj-between, cctree)
" TODO: Extraction function (clear out a register, input regex and scope, append matches into buffer)
" TODO: Update comment changing mapping to support more languages and comment styles

" Pathogen, for easy git based vimrc management
runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()

" General settings
filetype on
filetype plugin on
filetype plugin indent on
syntax on
colors evening
set nocompatible
set autoindent
set expandtab
set ruler
set number
set shiftwidth=4
set softtabstop=4
set tabstop=4
set bs=2
set mouse=""  " No mouse
set wildmenu
set wildmode=list:longest,full
set history=1000
set nowrap
set noincsearch
set title
set nojoinspaces
set noshowmatch

" Fix default grep settings
set grepprg=grep\ -n\ -H\ $*

" Fix slow completion
set complete-=i

" Fix stupid comment behavior
if has("autocmd")
    autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
endif

" Persistent undo
if exists('+undofile')
    set undofile
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

endif

" Eclim settings
if has("autocmd") 
    autocmd Filetype java let g:EclimCompletionMethod = 'omnifunc'
endif 

" Mathematical functions
if has("python") && executable("python")
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

" Solves the given mathemical expression and returns the result
function! EvalMathExpression(exp) 
    execute "python sys.argv = [\"" . a:exp . "\"]"
    python sys.argv[0] = eval(sys.argv[0])
    python vim.command("let out = \"" + str(sys.argv[0]) + "\"")
    return out
endfunction

" Replaces the mathematical expression defined by the motion with the result of the expression
function! MathExpressionOperator(type) 
    let sel_save = &selection
    let &selection = "inclusive"
    let reg_save = @@
    let start = "`["

    if a:type ==# "v"
        silent execute "normal! `<v`>d"
        let start = "`<"
    elseif a:type == 'line'
        silent execute "normal! `[V`]d"
    elseif a:type == 'block'
        silent execute "normal! `[`]d"
    else
        silent execute "normal! `[v`]d"
    endif

    let out = EvalMathExpression(@@)
    let command = "normal " . start . "i" . out
    silent execute command

    let &selection = sel_save
    let @@ = reg_save
endfunction

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
    silent execute "grep! -r " . shellescape(a:arg)
    cw
endfunction

" Greps in the current window
function! GrepCurrent(arg)
    silent execute "grep! " . shellescape(a:arg) . " % "
    cw
endfunction

" Greps in all buffers 
function! GrepBuffers(arg)
    call ClearCw()
    call BufDo("silent grepadd! " . shellescape(a:arg) . " %")
    cw
endfunction

" Greps in all windows
function! GrepWindows(arg) 
    call ClearCw()
    windo silent execute "grepadd! " . shellescape(a:arg) . " %"
    cw
endfunction

" Greps recursively for all directories in the path
function! GrepPath(arg)
    let plist = GetPathString()
    silent execute "grep! -r \"" . shellescape(a:arg) . "\" " . plist
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

" Wraps operator functions that rely on simple input text
function! OperatorWrapper(type) 
    let sel_save = &selection
    let &selection = "inclusive"
    let reg_save = @@

    if a:type ==# "v"
        silent execute "normal! `<v`>y"
    elseif a:type == 'line'
        silent execute "normal! '[V']y"
    elseif a:type == 'block'
        silent execute "normal! `[`]y"
    else
        silent execute "normal! `[v`]y"
    endif

    let command = substitute(g:OperatorWrapperCb, "\%s", shellescape(@@), "g")
    silent execute command

    let &selection = sel_save
    let @@ = reg_save
endfunction

" Based on the type of the motion, returns the associated range string
function! GetRange(type)
    if a:type ==# "V"
        return "'<,'>"
    elseif a:type ==# "v"
        return "'<,'>"
    else
        return "'[,']"
    endif
endfunction

" Creates a table from space separated arguments
function! TableOperator(type)
    let range = GetRange(a:type)
    silent execute ":" . range . "!column -t"
endfunction

" Creates a table from comma separated arguments
function! CommaTableOperator(type)
    let range = GetRange(a:type)
    silent execute ":" . range . "!column -s, -t"
endfunction

" Converts unix text to mac
function! UnixToMacOperator(type)
    let range = GetRange(a:type)
    silent execute ":" . range . "!unix2mac -f"
endfunction

" Converts mac text to unix
function! MacToUnixOperator(type)
    let range = GetRange(a:type)
    silent execute ":" . range . "!mac2unix -f"
endfunction

" Converts dos text to unix
function! DosToUnixOperator(type)
    let range = GetRange(a:type)
    silent execute ":" . range . "!dos2unix -f"
endfunction

" Converts unix text to dos
function! UnixToDosOperator(type)
    let range = GetRange(a:type)
    silent execute ":" . range . "!unix2dos -f"
endfunction

" Runs astyle on specified text
function! AstyleOperator(type) 
    let range = GetRange(a:type)
    silent execute ":" . range . "!astyle " . g:astyle
endfunction

" Converts cpp name mangled strings to their pretty counterparts
function! CppFilterOperator(type)
    let range = GetRange(a:type)
    silent execute ":" . range . "!c++filt"
endfunction

" TODO: Update output removing extra junk
" Performs crc32 on selected text
function! CrcOperator(type) 
    let range = GetRange(a:type)
    silent execute ":" . range . "!cksum -"
endfunction

" TODO: Update output removing extra junk
" Performs md5 on selected text
function! Md5Operator(type) 
    let range = GetRange(a:type)
    silent execute ":" . range . "!md5sum -"
endfunction

" Base64 encodes text
function! Base64Operator(type) 
    let range = GetRange(a:type)
    silent execute ":" . range . "!base64 -"
endfunction

" Base64 decodes text
function! Base64DecodeOperator(type) 
    let range = GetRange(a:type)
    silent execute ":" . range . "!base64 -d -"
endfunction

" TODO: Fix awkwardness surrounding line endings
" Replace the text selected by the motion with the unnamed buffer
function! ReplaceText(type)
    let sel_save = &selection
    let &selection = "inclusive"
    let reg_save = @@

    if a:type ==# "v"
        silent execute "normal! `<v`>\"_dp"
        let start = "`<"
    elseif a:type == 'line'
        silent execute "normal! `[V`]\"_dp"
    elseif a:type == 'block'
        silent execute "normal! `[`]\"_dp"
    else
        silent execute "normal! `[v`]\"_dp"
    endif

    let &selection = sel_save
    let @@ = reg_save
endfunction

let mapleader="\\"

" Additional cscope mappings
nnoremap <C-\>r :call CscopeRescanRecurse()<CR>
nnoremap <C-\>p :call CscopeRescanAll()<CR>

" Grep operator mappings
nnoremap <leader>gp :set operatorfunc=OperatorWrapper<CR>:let g:OperatorWrapperCb="call GrepPath(%s)"<CR>g@
vnoremap <leader>gp :<c-u>let g:OperatorWrapperCb="call GrepPath(%s)"<CR>:<c-u>call OperatorWrapper(visualmode())<CR>

nnoremap <leader>gr :set operatorfunc=OperatorWrapper<CR>:let g:OperatorWrapperCb="call GrepRecurse(%s)"<CR>g@
vnoremap <leader>gr :<c-u>let g:OperatorWrapperCb="call GrepRecurse(%s)"<CR>:<c-u>call OperatorWrapper(visualmode())<CR>

nnoremap <leader>gc :set operatorfunc=OperatorWrapper<CR>:let g:OperatorWrapperCb="call GrepCurrent(%s)"<CR>g@
vnoremap <leader>gc :<c-u>let g:OperatorWrapperCb="call GrepCurrent(%s)"<CR>:<c-u>call OperatorWrapper(visualmode())<CR>

nnoremap <leader>gb :set operatorfunc=OperatorWrapper<CR>:let g:OperatorWrapperCb="call GrepBuffers(%s)"<CR>g@
vnoremap <leader>gb :<c-u>let g:OperatorWrapperCb="call GrepBuffers(%s)"<CR>:<c-u>call OperatorWrapper(visualmode())<CR>

nnoremap <leader>gw :set operatorfunc=OperatorWrapper<CR>:let g:OperatorWrapperCb="call GrepWindows(%s)"<CR>g@
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
nnoremap <leader>tc :%s/\/\/[ ]*\([^ ]\)/\/\/ \U\1/<CR>

nnoremap <leader>ta :set operatorfunc=AstyleOperator<CR>g@
vnoremap <leader>ta :<c-u>call AstyleOperator(visualmode())<CR>

nnoremap <leader>tud :set operatorfunc=UnixToDosOperator<CR>g@
vnoremap <leader>tud :<c-u>call UnixToDosOperator(visualmode())<CR>

nnoremap <leader>tdu :set operatorfunc=DosToUnixOperator<CR>g@
vnoremap <leader>tdu :<c-u>call DosToUnixOperator(visualmode())<CR>

nnoremap <leader>tmu :set operatorfunc=MacToUnixOperator<CR>g@
vnoremap <leader>tmu :<c-u>call MacToUnixOperator(visualmode())<CR>

nnoremap <leader>tum :set operatorfunc=UnixToMacOperator<CR>g@
vnoremap <leader>tum :<c-u>call UnixToMacOperator(visualmode())<CR>

nnoremap <leader>tt :set operatorfunc=TableOperator<CR>g@
vnoremap <leader>tt :<c-u>call TableOperator(visualmode())<CR>

nnoremap <leader>ts :set operatorfunc=CommaTableOperator<CR>g@
vnoremap <leader>ts :<c-u>call CommaTableOperator(visualmode())<CR>

nnoremap <leader>tb :set operatorfunc=Base64Operator<CR>g@
vnoremap <leader>tb :<c-u>call Base64Operator(visualmode())<CR>

nnoremap <leader>tB :set operatorfunc=Base64DecodeOperator<CR>g@
vnoremap <leader>tB :<c-u>call Base64DecodeOperator(visualmode())<CR>

nnoremap <leader>t5 :set operatorfunc=Md5Operator<CR>g@
vnoremap <leader>t5 :<c-u>call Md5Operator(visualmode())<CR>

nnoremap <leader>tk :set operatorfunc=CrcOperator<CR>g@
vnoremap <leader>tk :<c-u>call CrcOperator(visualmode())<CR>

nnoremap <leader>tp :set operatorfunc=CppFilterOperator<CR>g@
vnoremap <leader>tp :<c-u>call CppFilterOperator(visualmode())<CR>

nnoremap <leader>tm :set operatorfunc=MathExpressionOperator<CR>g@
vnoremap <leader>tm :<c-u>call MathExpressionOperator(visualmode())<CR>

" vimrc reload mappings
nnoremap <leader>lg :source ~/.vimrc<CR>
nnoremap <leader>ll :source ./.vimrc<CR>

" Misc
nnoremap <leader>p :set operatorfunc=ReplaceText<CR>g@
vnoremap <leader>p :<c-u>call ReplaceText(visualmode())<CR>
nnoremap <leader>k :make<CR>
inoremap <leader>t // TODO: 
inoremap jj <ESC>

