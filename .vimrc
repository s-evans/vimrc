" TODO: Left/Right expression text object
" TODO: Update textobj-between mapping to avoid collisions
" TODO: Improve spreadsheet functionality
" TODO: Function for cd dir, execute a:command_string, cd -
" TODO: Function for linenum, execute a:command_string, linenum G
" TODO: Fork changes? (textobj-between, cctree)
" TODO: Extraction function (clear out a register, input regex and scope, append matches into buffer)
" TODO: Update comment changing mapping to support more languages and comment styles
" TODO: Syntax highlighting for command line program output (readelf, nm, objdump)

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

" Eclim settings
if has("autocmd") 
    autocmd Filetype java let g:EclimCompletionMethod = 'omnifunc'
endif 

" Cscope settings
if has("cscope") && executable("cscope")
    set nocscopeverbose
    set cscopequickfix=s-,c-,d-,i-,t-,e-,g-
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

" Executes a cscope rescan on the current directory recursively
function! CscopeRescan()
    " Special case for java; Get the list of java files;
    let ft = &filetype
    if ft == "java"
        silent !find * -type f | grep "\.java$" > cscope.files
    endif

    " Execute Cscope rescan
    silent !cscope -Rbqk
endfunction

" Executes a cscope rescan on the given directory recursively
function! CscopeRescanDir(dir)
    silent! execute "cd " . a:dir
    call CscopeRescan()
    cd -
endfunction

" Returns a list of connected cscope databases
function! CscopeGetDbLines()
    redir =>cslist
    silent! cscope show
    redir END
    return split(cslist, '\n')
endfunction

" Returns a list of paths of connected cscope databases
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

" Rescans all currently connected cscope databases for changes
function! CscopeRescanAll()
    let paths = CscopeGetDbPaths()

    for pth in paths
        call CscopeRescanDir(pth)
    endfor

    cs reset
    redraw!
endfunction

" Rescans the cscope database in the current directory
function! CscopeRescanRecurse()
    call CscopeRescan()
    cs reset
    redraw!
endfunction

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

    if a:type ==# 'v' || a:type ==# 'V' || a:type == ''
        normal! gvp
    elseif a:type == 'line'
        normal! `[V`]p
    elseif a:type == 'block' 
        normal! `[\<C-V>`]p
    else
        normal! `[v`]p
    endif

    let &selection = sel_save
    let @@ = reg_save
endfunction

" Used as an operator function with a callback. Passes arguments via the unnamed buffer.
function! UnnamedOperatorWrapper(type) 
    let sel_save = &selection
    let &selection = "inclusive"
    let reg_save = @@

    if a:type ==# 'v' || a:type ==# 'V' || a:type == ''
        normal! gvy
    elseif a:type == 'line'
        normal! `[V`]y
    elseif a:type == 'block'
        normal! `[\<C-V>`]y
    else
        normal! `[v`]y
    endif

    silent execute g:OperatorWrapperCb

    if a:type ==# 'v' || a:type ==# 'V' || a:type == ''
        call setreg("@@", getreg("@@"), a:type)
        normal! gvp
    elseif a:type == 'line'
        normal! `[V`]p
    elseif a:type == 'block' 
        normal! `[\<C-V>`]p
    else
        normal! `[v`]p
    endif

    let &selection = sel_save
    let @@ = reg_save
endfunction

" Wraps operator functions that rely on simple input text
function! OperatorWrapper(type) 
    let sel_save = &selection
    let &selection = "inclusive"
    let reg_save = @@

    if a:type ==# 'v' || a:type ==# 'V' || a:type == ''
        normal! gvy
    elseif a:type == 'line'
        normal! `[V`]y
    elseif a:type == 'block' 
        normal! `[\<C-V>`]y
    else
        normal! `[v`]y
    endif

    let command = substitute(g:OperatorWrapperCb, "\%s", shellescape(@@), "g")
    silent execute command

    let &selection = sel_save
    let @@ = reg_save
endfunction

" Splits up values
function! SplitUnnamed()
    let delimiter = input("Enter delimiter: ")
    let @@ = join(split(@@, delimiter), "\n")
endfunction

" Removes duplicates
function! UniqueUnnamed()
    let @@ = join(uniq(sort(split(@@, "\n"))), "\n")
endfunction

" Sorts the given text
function! SortUnnamed()
    let @@ = join(sort(split(@@, "\n")), "\n")
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
    let @@ = system("cksum", @@)
    let @@ = substitute(@@, "\\n", "", "g")
    let @@ = substitute(@@, " .*", "", "g")
endfunction

" Performs md5 on selected text
function! Md5Unnamed() 
    let @@ = system("md5sum", @@)
    let @@ = substitute(@@, "\\n", "", "g")
    let @@ = substitute(@@, " .*", "", "g")
endfunction

" Base64 encodes text
function! Base64Unnamed() 
    let @@ = system("base64", @@)
    let @@ = substitute(@@, "\\n", "", "g")
endfunction
 
" Base64 decodes text
function! Base64DecodeUnnamed() 
    let @@ = system("base64 -d", @@)
    let @@ = substitute(@@, "\\n", "", "g")
endfunction

" Used to set up a visual mode operator mapping
function! VisualMapper(callbackString, operatorFunction)
    let g:OperatorWrapperCb=a:callbackString
    silent execute "call " . a:operatorFunction . "(visualmode())"
endfunction

" Used to set up a normal mode operator mapping
function! NormalMapper(callbackString, operatorFunction)
    let g:OperatorWrapperCb=a:callbackString
    silent execute "set operatorfunc=" . a:operatorFunction
endfunction

let mapleader="\\"

" Additional cscope mappings
nnoremap <C-\>r :call CscopeRescanRecurse()<CR>
nnoremap <C-\>p :call CscopeRescanAll()<CR>

" Grep operator mappings
nnoremap <leader>gp :call NormalMapper("call GrepPath(%s)", "OperatorWrapper")<CR>g@
vnoremap <leader>gp :<c-u>call VisualMapper("call GrepPath(%s)", "OperatorWrapper")<CR>

nnoremap <leader>gr :call NormalMapper("call GrepRecurse(%s)", "OperatorWrapper")<CR>g@
vnoremap <leader>gr :<c-u>call VisualMapper("call GrepRecurse(%s)", "OperatorWrapper")<CR>

nnoremap <leader>gc :call NormalMapper("call GrepCurrent(%s)", "OperatorWrapper")<CR>g@
vnoremap <leader>gc :<c-u>call VisualMapper("call GrepCurrent(%s)", "OperatorWrapper")<CR>

nnoremap <leader>gb :call NormalMapper("call GrepBuffers(%s)", "OperatorWrapper")<CR>g@
vnoremap <leader>gb :<c-u>call VisualMapper("call GrepBuffers(%s)", "OperatorWrapper")<CR>

nnoremap <leader>gw :call NormalMapper("call GrepWindows(%s)", "OperatorWrapper")<CR>g@
vnoremap <leader>gw :<c-u>call VisualMapper("call GrepWindows(%s)", "OperatorWrapper")<CR>

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
    autocmd FileType xml nnoremap <buffer> <leader>ta :call NormalMapper("call XmlLintUnnamed()", "UnnamedOperatorWrapper")<CR>g@
    autocmd FileType xml vnoremap <buffer> <leader>ta :<c-u>call VisualMapper("call XmlLintUnnamed()", "UnnamedOperatorWrapper")<CR>
endif

nnoremap <leader>ta :call NormalMapper("call AstyleUnnamed()", "UnnamedOperatorWrapper")<CR>g@
vnoremap <leader>ta :<c-u>call VisualMapper("call AstyleUnnamed()", "UnnamedOperatorWrapper")<CR>

nnoremap <leader>tud :call NormalMapper("call UnixToDosUnnamed()", "UnnamedOperatorWrapper")<CR>g@
vnoremap <leader>tud :<c-u>call VisualMapper("call UnixToDosUnnamed()", "UnnamedOperatorWrapper")<CR>

nnoremap <leader>tdu :call NormalMapper("call DosToUnixUnnamed()", "UnnamedOperatorWrapper")<CR>g@
vnoremap <leader>tdu :<c-u>call VisualMapper("call DosToUnixUnnamed()", "UnnamedOperatorWrapper")<CR>

nnoremap <leader>tmu :call NormalMapper("call MacToUnixUnnamed()", "UnnamedOperatorWrapper")<CR>g@
vnoremap <leader>tmu :<c-u>call VisualMapper("call MacToUnixUnnamed()", "UnnamedOperatorWrapper")<CR>

nnoremap <leader>tum :call NormalMapper("call UnixToMacUnnamed()", "UnnamedOperatorWrapper")<CR>g@
vnoremap <leader>tum :<c-u>call VisualMapper("call UnixToMacUnnamed()", "UnnamedOperatorWrapper")<CR>

nnoremap <leader>ts :call NormalMapper("call CommaTableUnnamed()", "UnnamedOperatorWrapper")<CR>g@
vnoremap <leader>ts :<c-u>call VisualMapper("call CommaTableUnnamed()", "UnnamedOperatorWrapper")<CR>

nnoremap <leader>tb :call NormalMapper("call Base64Unnamed()", "UnnamedOperatorWrapper")<CR>g@
vnoremap <leader>tb :<c-u>call VisualMapper("call Base64Unnamed()", "UnnamedOperatorWrapper")<CR>

nnoremap <leader>tB :call NormalMapper("call Base64DecodeUnnamed()", "UnnamedOperatorWrapper")<CR>g@
vnoremap <leader>tB :<c-u>call VisualMapper("call Base64DecodeUnnamed()", "UnnamedOperatorWrapper")<CR>

nnoremap <leader>t5 :call NormalMapper("call Md5Unnamed()", "UnnamedOperatorWrapper")<CR>g@
vnoremap <leader>t5 :<c-u>call VisualMapper("call Md5Unnamed()", "UnnamedOperatorWrapper")<CR>

nnoremap <leader>tk :call NormalMapper("call CrcUnnamed()", "UnnamedOperatorWrapper")<CR>g@
vnoremap <leader>tk :<c-u>call VisualMapper("call CrcUnnamed()", "UnnamedOperatorWrapper")<CR>

nnoremap <leader>tp :call NormalMapper("call CppFilterUnnamed()", "UnnamedOperatorWrapper")<CR>g@
vnoremap <leader>tp :<c-u>call VisualMapper("call CppFilterUnnamed()", "UnnamedOperatorWrapper")<CR>

nnoremap <leader>tm :call NormalMapper("call MathExpressionUnnamed()", "UnnamedOperatorWrapper")<CR>g@
vnoremap <leader>tm :<c-u>call VisualMapper("call MathExpressionUnnamed()", "UnnamedOperatorWrapper")<CR>

nnoremap <leader>ti :call NormalMapper("call TitleCaseUnnamed()", "UnnamedOperatorWrapper")<CR>g@
vnoremap <leader>ti :<c-u>call VisualMapper("call TitleCaseUnnamed()", "UnnamedOperatorWrapper")<CR>

nnoremap <leader>tt :call NormalMapper("call TableUnnamed()", "UnnamedOperatorWrapper")<CR>g@
vnoremap <leader>tt :<c-u>call VisualMapper("call TableUnnamed()", "UnnamedOperatorWrapper")<CR>

nnoremap <leader>tr :call NormalMapper("call SortUnnamed()", "UnnamedOperatorWrapper")<CR>g@
vnoremap <leader>tr :<c-u>call VisualMapper("call SortUnnamed()", "UnnamedOperatorWrapper")<CR>

nnoremap <leader>tu :call NormalMapper("call UniqueUnnamed()", "UnnamedOperatorWrapper")<CR>g@
vnoremap <leader>tu :<c-u>call VisualMapper("call UniqueUnnamed()", "UnnamedOperatorWrapper")<CR>

nnoremap <leader>tl :call NormalMapper("call SplitUnnamed()", "UnnamedOperatorWrapper")<CR>g@
vnoremap <leader>tl :<c-u>call VisualMapper("call SplitUnnamed()", "UnnamedOperatorWrapper")<CR>

" vimrc reload mappings
nnoremap <leader>lg :source ~/.vimrc<CR>
nnoremap <leader>ll :source ./.vimrc<CR>

" Misc
nnoremap <leader>p :set operatorfunc=ReplaceText<CR>g@
vnoremap <leader>p :<c-u>call ReplaceText(visualmode())<CR>
nnoremap <leader>k :make<CR>
inoremap <leader>t // TODO: 
inoremap jj <ESC>

