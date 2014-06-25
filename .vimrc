" TODO: Syntax highlighting for command line program output (readelf, nm, objdump)
" TODO: Left/Right expression text object
" TODO: Improve spreadsheet functionality
" TODO: Function for cd dir, execute a:command_string, cd -
" TODO: Function for linenum, execute a:command_string, linenum G
" TODO: Fork changes? (textobj-between, cctree)
" TODO: Update textobj-between mapping to avoid collisions
" TODO: Extraction function (clear out a register, input regex and scope, append matches into buffer)
" TODO: Update comment changing mapping to support more languages and comment styles
" TODO: Text transform operators (split, transpose, rotate)
" TODO: Update text transforms removing extra output (newlines and junk values)

" Pathogen, for easy git based vimrc management
runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()

" General settings
filetype on
filetype plugin on
filetype plugin indent on
syntax on
colors evening
set nolinebreak
set textwidth=0
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

" Replace the text selected by the motion with the unnamed buffer
function! ReplaceText(type)
    let sel_save = &selection
    let &selection = "inclusive"
    let reg_save = @@

    if a:type ==# 'v' || a:type ==# 'V'
        silent execute "normal! `<" . a:type . "`>p"
    elseif a:type == 'line'
        silent execute "normal! `[V`]p"
    elseif a:type == 'block' || a:type == ''
        silent execute "normal! `[\<c-v>`]p"
    else
        silent execute "normal! `[v`]p"
    endif

    let &selection = sel_save
    let @@ = reg_save
endfunction

" Used as an operator function with a callback. Passes arguments via the unnamed buffer.
function! UnnamedOperatorWrapper(type) 
    let sel_save = &selection
    let &selection = "inclusive"
    let reg_save = @@

    if a:type ==# 'v' || a:type ==# 'V'
        silent execute "normal! `<" . a:type . "`>y"
    elseif a:type == 'line'
        silent execute "normal! `[V`]y"
    elseif a:type == 'block' || a:type == ''
        silent execute "normal! `[\<c-v>`]y"
    else
        silent execute "normal! `[v`]y"
    endif

    silent execute g:OperatorWrapperCb

    if a:type ==# 'v' || a:type ==# 'V'
        silent execute "normal! `<" . a:type . "`>p"
    elseif a:type == 'line'
        silent execute "normal! `[V`]p"
    elseif a:type == 'block' || a:type == ''
        silent execute "normal! `[\<c-v>`]p"
    else
        silent execute "normal! `[v`]p"
    endif

    let &selection = sel_save
    let @@ = reg_save
endfunction

" Wraps operator functions that rely on simple input text
function! OperatorWrapper(type) 
    let sel_save = &selection
    let &selection = "inclusive"
    let reg_save = @@

    if a:type ==# 'v' || a:type ==# 'V'
        silent execute "normal! `<" . a:type . "`>y"
    elseif a:type == 'line'
        silent execute "normal! `[V`]y"
    elseif a:type == 'block' || a:type == ''
        silent execute "normal! `[\<c-v>`]y"
    else
        silent execute "normal! `[v`]y"
    endif

    let command = substitute(g:OperatorWrapperCb, "\%s", shellescape(@@), "g")
    silent execute command

    let &selection = sel_save
    let @@ = reg_save
endfunction

" Evaluates mathematical expressions
function! MathExpressionUnnamed() 
    let @@ = EvalMathExpression(@@)
endfunction

" Makes XML prettier
function! XmlLintUnnamed()
    let @@ = system("xmllint --format -", @@)
endfunction

" Makes text title case
function! TitleCaseUnnamed()
    let @@ = substitute(@@, "\\v<(.)(\\w*)>", "\\u\\1\\L\\2", "g") 
endfunction

" Creates a table from space separated arguments
function! TableUnnamed()
    let @@ = system("column -t", @@)
endfunction

" Creates a table from comma separated arguments
function! CommaTableUnnamed()
    let @@ = system("column -s, -t", @@)
endfunction

" Converts unix text to mac
function! UnixToMacUnnamed()
    let @@ = system("unix2mac -f", @@)
endfunction

" Converts mac text to unix
function! MacToUnixUnnamed()
    let @@ = system("mac2unix -f", @@)
endfunction

" Converts dos text to unix
function! DosToUnixUnnamed()
    let @@ = system("dos2unix -f", @@)
endfunction

" Converts unix text to dos
function! UnixToDosUnnamed()
    let @@ = system("unix2dos -f", @@)
endfunction

" Runs astyle on specified text
function! AstyleUnnamed() 
    let @@ = system("astyle " . g:astyle, @@)
endfunction

" Converts cpp name mangled strings to their pretty counterparts
function! CppFilterUnnamed()
    let @@ = system("c++filt", @@)
endfunction

" Performs crc32 on selected text
function! CrcUnnamed() 
    let @@ = system("cksum | sed 's/\\(^[^ ]*\\).*/\\1/'", @@)
endfunction

" Performs md5 on selected text
function! Md5Unnamed() 
    let @@ = system("md5sum -", @@)
endfunction

" Base64 encodes text
function! Base64Unnamed() 
    let @@ = system("base64 -", @@)
endfunction
 
" Base64 decodes text
function! Base64DecodeUnnamed() 
    let @@ = system("base64 -d -", @@)
endfunction

let mapleader="\\"

" Additional cscope mappings
nnoremap <C-\>r :call CscopeRescanRecurse()<CR>
nnoremap <C-\>p :call CscopeRescanAll()<CR>

" Grep operator mappings
nnoremap <leader>gp :let g:OperatorWrapperCb="call GrepPath(%s)"<CR>:set operatorfunc=OperatorWrapper<CR>g@
vnoremap <leader>gp :<c-u>let g:OperatorWrapperCb="call GrepPath(%s)"<CR>:<c-u>call OperatorWrapper(visualmode())<CR>

nnoremap <leader>gr :let g:OperatorWrapperCb="call GrepRecurse(%s)"<CR>:set operatorfunc=OperatorWrapper<CR>g@
vnoremap <leader>gr :<c-u>let g:OperatorWrapperCb="call GrepRecurse(%s)"<CR>:<c-u>call OperatorWrapper(visualmode())<CR>

nnoremap <leader>gc :let g:OperatorWrapperCb="call GrepCurrent(%s)"<CR>:set operatorfunc=OperatorWrapper<CR>g@
vnoremap <leader>gc :<c-u>let g:OperatorWrapperCb="call GrepCurrent(%s)"<CR>:<c-u>call OperatorWrapper(visualmode())<CR>

nnoremap <leader>gb :let g:OperatorWrapperCb="call GrepBuffers(%s)"<CR>:set operatorfunc=OperatorWrapper<CR>g@
vnoremap <leader>gb :<c-u>let g:OperatorWrapperCb="call GrepBuffers(%s)"<CR>:<c-u>call OperatorWrapper(visualmode())<CR>

nnoremap <leader>gw :let g:OperatorWrapperCb="call GrepWindows(%s)"<CR>:set operatorfunc=OperatorWrapper<CR>g@
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

" Override astyle map for xml
if has("autocmd") 
    autocmd FileType xml nnoremap <buffer> <leader>ta :let g:OperatorWrapperCb="call XmlLintUnnamed()"<CR>:set operatorfunc=UnnamedOperatorWrapper<CR>g@
    autocmd FileType xml vnoremap <buffer> <leader>ta :<c-u>let g:OperatorWrapperCb="call XmlLintUnnamed()"<CR>:<c-u>call UnnamedOperatorWrapper(visualmode())<CR>
endif

nnoremap <leader>ta :let g:OperatorWrapperCb="call AstyleUnnamed()"<CR>:set operatorfunc=UnnamedOperatorWrapper<CR>g@
vnoremap <leader>ta :<c-u>let g:OperatorWrapperCb="call AstyleUnnamed()"<CR>:<c-u>call UnnamedOperatorWrapper(visualmode())<CR>

nnoremap <leader>tud :let g:OperatorWrapperCb="call UnixToDosUnnamed()"<CR>:set operatorfunc=UnnamedOperatorWrapper<CR>g@
vnoremap <leader>tud :<c-u>let g:OperatorWrapperCb="call UnixToDosUnnamed()"<CR>:<c-u>call UnnamedOperatorWrapper(visualmode())<CR>

nnoremap <leader>tdu :let g:OperatorWrapperCb="call DosToUnixUnnamed()"<CR>:set operatorfunc=UnnamedOperatorWrapper<CR>g@
vnoremap <leader>tdu :<c-u>let g:OperatorWrapperCb="call DosToUnixUnnamed()"<CR>:<c-u>call UnnamedOperatorWrapper(visualmode())<CR>

nnoremap <leader>tmu :let g:OperatorWrapperCb="call MacToUnixUnnamed()"<CR>:set operatorfunc=UnnamedOperatorWrapper<CR>g@
vnoremap <leader>tmu :<c-u>let g:OperatorWrapperCb="call MacToUnixUnnamed()"<CR>:<c-u>call UnnamedOperatorWrapper(visualmode())<CR>

nnoremap <leader>tum :let g:OperatorWrapperCb="call UnixToMacUnnamed()"<CR>:set operatorfunc=UnnamedOperatorWrapper<CR>g@
vnoremap <leader>tum :<c-u>let g:OperatorWrapperCb="call UnixToMacUnnamed()"<CR>:<c-u>call UnnamedOperatorWrapper(visualmode())<CR>

nnoremap <leader>ts :let g:OperatorWrapperCb="call CommaTableUnnamed()"<CR>:set operatorfunc=UnnamedOperatorWrapper<CR>g@
vnoremap <leader>ts :<c-u>let g:OperatorWrapperCb="call CommaTableUnnamed()"<CR>:<c-u>call UnnamedOperatorWrapper(visualmode())<CR>

nnoremap <leader>tb :let g:OperatorWrapperCb="call Base64Unnamed()"<CR>:set operatorfunc=UnnamedOperatorWrapper<CR>g@
vnoremap <leader>tb :<c-u>let g:OperatorWrapperCb="call Base64Unnamed()"<CR>:<c-u>call UnnamedOperatorWrapper(visualmode())<CR>

nnoremap <leader>tB :let g:OperatorWrapperCb="call Base64DecodeUnnamed()"<CR>:set operatorfunc=UnnamedOperatorWrapper<CR>g@
vnoremap <leader>tB :<c-u>let g:OperatorWrapperCb="call Base64DecodeUnnamed()"<CR>:<c-u>call UnnamedOperatorWrapper(visualmode())<CR>

nnoremap <leader>t5 :let g:OperatorWrapperCb="call Md5Unnamed()"<CR>:set operatorfunc=UnnamedOperatorWrapper<CR>g@
vnoremap <leader>t5 :<c-u>let g:OperatorWrapperCb="call Md5Unnamed()"<CR>:<c-u>call UnnamedOperatorWrapper(visualmode())<CR>

nnoremap <leader>tk :let g:OperatorWrapperCb="call CrcUnnamed()"<CR>:set operatorfunc=UnnamedOperatorWrapper<CR>g@
vnoremap <leader>tk :<c-u>let g:OperatorWrapperCb="call CrcUnnamed()"<CR>:<c-u>call UnnamedOperatorWrapper(visualmode())<CR>

nnoremap <leader>tp :let g:OperatorWrapperCb="call CppFilterUnnamed()"<CR>:set operatorfunc=UnnamedOperatorWrapper<CR>g@
vnoremap <leader>tp :<c-u>let g:OperatorWrapperCb="call CppFilterUnnamed()"<CR>:<c-u>call UnnamedOperatorWrapper(visualmode())<CR>

nnoremap <leader>tm :let g:OperatorWrapperCb="call MathExpressionUnnamed()"<CR>:set operatorfunc=UnnamedOperatorWrapper<CR>g@
vnoremap <leader>tm :<c-u>let g:OperatorWrapperCb="call MathExpressionUnnamed()"<CR>:<c-u>call UnnamedOperatorWrapper(visualmode())<CR>

nnoremap <leader>ti :let g:OperatorWrapperCb="call TitleCaseUnnamed()"<CR>:set operatorfunc=UnnamedOperatorWrapper<CR>g@
vnoremap <leader>ti :<c-u>let g:OperatorWrapperCb="call TitleCaseUnnamed()"<CR>:<c-u>call UnnamedOperatorWrapper(visualmode())<CR>

nnoremap <leader>tt :let g:OperatorWrapperCb="call TableUnnamed()"<CR>:set operatorfunc=UnnamedOperatorWrapper<CR>g@
vnoremap <leader>tt :<c-u>let g:OperatorWrapperCb="call TableUnnamed()"<CR>:<c-u>call UnnamedOperatorWrapper(visualmode())<CR>

" vimrc reload mappings
nnoremap <leader>lg :source ~/.vimrc<CR>
nnoremap <leader>ll :source ./.vimrc<CR>

" Misc
nnoremap <leader>p :set operatorfunc=ReplaceText<CR>g@
vnoremap <leader>p :<c-u>call ReplaceText(visualmode())<CR>
nnoremap <leader>k :make<CR>
inoremap <leader>t // TODO: 
inoremap jj <ESC>

