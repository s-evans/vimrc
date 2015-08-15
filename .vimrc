
" -------------------------------
" TODO List
" -------------------------------

" Table mode
" Refactoring operations
" Set operations: mean, median, mode, sum
" Extraction function (clear out a register, input regex and scope, append matches into buffer)
" Multiroot operations (rsync svn git sed cscope)
" Consider modifying cscope scan to always pull applicable file types into cscope.files
" Left/Right expression text object
" Column text object
" Easier help greping

" -------------------------------
" Plugin Setup
" -------------------------------

let s:my_vim_dir=fnamemodify(resolve(expand('<sfile>')), ':h')
call plug#begin(s:my_vim_dir . '/bundle')

Plug 'a-vim', {'on': [ 'A', 'AS', 'AV', 'AT', 'AN', 'IH', 'IHS', 'IHT', 'IHN' ] }
Plug 'bufexplorer'
Plug 'camel_case_motion'
Plug 'cctree' , { 'on': 'CCTreeLoadDB' }
Plug 'cmake_indent' , { 'for': 'cmake' }
Plug 'cmake_syntax' , { 'for': 'cmake' }
Plug 'dosbatch' , { 'for': 'dosbatch' }
Plug 'doxygen_toolkit' , { 'on': ['Dox', 'DoxAuthor'] }
Plug 'easy-align' , { 'on': '<Plug>(EasyAlign)' }
Plug 'gundo' , { 'on': 'GundoToggle' }
Plug 'matchit'
Plug 'nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'operator-replace'
Plug 'operator-user'
Plug 'snipmate'
Plug 'syntastic', { 'on': 'SyntasticCheck'}
Plug 'tagbar' , { 'on': 'TagbarToggle' }
Plug 'textobj-between'
Plug 'textobj-camel'
Plug 'textobj-comment'
Plug 'textobj-function'
Plug 'textobj-line'
Plug 'textobj-parameter'
Plug 'textobj-user'
Plug 'tlib_vim'
Plug 'vim-abolish'
Plug 'vim-addon-mw-utils'
Plug 'vim-commentary'
Plug 'vim-indent-object'
Plug 'vim-repeat'
Plug 'vim-snippets'
Plug 'vim-surround'
Plug 'vim-unimpaired'
Plug 'visualrepeat'
Plug 'ycm', {'for': [ 'cpp', 'c' ] }

call plug#end()

" -------------------------------
" General Settings
" -------------------------------

set nocompatible
colors evening
set autoindent
set bs=2
set expandtab
set history=1000
set laststatus=2
set lazyredraw
set mouse=""  " No mouse
set noincsearch
set nojoinspaces
set nolinebreak
set noshowmatch
set nowrap
set number
set shiftwidth=4
set smartcase
set softtabstop=4
set tabstop=4
set textwidth=0
set matchpairs+=<:>
let g:load_doxygen_syntax=1

if has('extra_search')
  set nohlsearch
endif

if has('cmdline_info')
  set ruler
endif

if has('autocmd')
  filetype on
  filetype plugin on
  filetype plugin indent on
endif

if has('syntax')
  syntax on
endif

if has('folding')
  set nofoldenable
endif

if has('title')
  set title
endif

if exists('&wildmode')
  set wildmenu
  set wildmode=list:longest,full
endif

if has('multi_byte')
  set encoding=utf-8
endif

" -------------------------------
" Ignorecase
" -------------------------------

set ignorecase

if exists("&wildignorecase")
  set wildignorecase
endif

if exists("&fileignorecase")
  set fileignorecase
endif

" -------------------------------
" Compiler Settings
" -------------------------------

" gcc ld linker errors
set errorformat+=%f:\(.text%*[^\ ]%m

" -------------------------------
" Grep Settings
" -------------------------------

set grepprg=grep\ -n\ -H\ "$@"

if executable("ack")
    set grepprg=ack\ -H\ --nocolor\ --nogroup\ --column
    set grepformat=%f:%l:%c:%m
endif

if executable("ag")
    set grepprg=ag\ --nogroup\ --nocolor\ --column
    set grepformat=%f:%l:%c:%m
endif

" -------------------------------
" Completion Settings
" -------------------------------

if has('insert_expand')
  " Don't scan includes for completion (slow)
  set complete-=i

  " Don't use the preview window
  set completeopt=menu,menuone
endif

" -------------------------------
" Cursor Settings
" -------------------------------

highlight CursorLine cterm=reverse term=reverse gui=reverse
highlight StatusLineNC ctermfg=Black ctermbg=DarkCyan guibg=DarkCyan cterm=none term=none gui=none
highlight StatusLine ctermfg=Black ctermbg=DarkCyan guibg=DarkCyan cterm=none term=none gui=none
highlight VertSplit ctermfg=Black ctermbg=DarkCyan guibg=DarkCyan cterm=none term=none gui=none
set fillchars=vert:\|,fold:-,stl:\-,stlnc:\ 
set cursorline

" -------------------------------
" Directory .vimrc Settings
" -------------------------------

set exrc
set secure

" -------------------------------
" Persistent Undo Settings
" -------------------------------

if exists('+undofile')
  set undofile
endif

" -------------------------------
" YouCompleteMe Settings
" -------------------------------

" Auto-load ycm config file
let g:ycm_confirm_extra_conf = 0
let g:ycm_show_diagnostics_ui = 0

" -------------------------------
" Syntastic Settings
" -------------------------------

let g:syntastic_check_on_open = 0

" -------------------------------
" Ultisnips Settings
" -------------------------------

" Deal with interactions between ycm and ultisnips
let g:ycm_key_list_select_completion = ['<C-TAB>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-S-TAB>', '<Up>']

" -------------------------------
" Easy Align Settings
" -------------------------------

" Add some delimiters
let g:easy_align_delimiters = {
\ '^': {
\     'pattern':        '[^\w]',
\     'left_margin':    0,
\     'right_margin':   0,
\     'stick_to_left':  0
\   },
\ '>': { 'pattern': '>>\|=>\|>' },
\ '<': { 'pattern': '<<\|=<\|<' },
\ '\': { 'pattern': '\\' },
\ '/': { 'pattern': '//\+\|/\*\|\*/', 'delimiter_align': 'l', 'ignore_groups': ['!Comment'] },
\ '[': {
\     'pattern':       '\[',
\     'left_margin':   0,
\     'right_margin':  0,
\     'stick_to_left': 0
\   },
\ ']': {
\     'pattern':       '\]',
\     'left_margin':   0,
\     'right_margin':  0,
\     'stick_to_left': 0
\   },
\ '(': {
\     'pattern':       '(',
\     'left_margin':   0,
\     'right_margin':  0,
\     'stick_to_left': 0
\   },
\ ')': {
\     'pattern':       ')',
\     'left_margin':   0,
\     'right_margin':  0,
\     'stick_to_left': 0
\   },
\ 'f': {
\     'pattern': ' \(\S\+(\)\@=',
\     'left_margin': 0,
\     'right_margin': 0
\   },
\ 'd': {
\     'pattern': ' \(\S\+\s*[;=]\)\@=',
\     'left_margin': 0,
\     'right_margin': 0
\   }
\ }

" -------------------------------
" Eclim Settings
" -------------------------------

" Enable eclim completion only on java files
if has("autocmd") 
  augroup eclim_java_completion
    autocmd!
    autocmd BufEnter *.java let g:EclimCompletionMethod = 'omnifunc'
    autocmd BufLeave *.java unlet g:EclimCompletionMethod
  augroup END
endif 

" -------------------------------
" Auto-format Settings
" -------------------------------

" Remove comment header when joining lines
if has('patch-7.3.541')
  set formatoptions+=j
endif

" Records the current formatprg and sets a new formatprg
function! SetFormatProgram( string )
  let g:oldformatprg=&formatprg
  exec "set formatprg=" . substitute( a:string, " ", "\\\\ ", "g" )
endfunction

" Sets the formatprg
function! InitializeFormatProgram( string )
  let g:oldformatprg=a:string
  exec "set formatprg=" . substitute( a:string, " ", "\\\\ ", "g" )
endfunction

" Restores the formatprg to previous settings
function! RestoreFormatProgram()
  exec "set formatprg=" . substitute( g:oldformatprg, " ", "\\\\ ", "g" )
endfunction

" Set up default format program
call InitializeFormatProgram("")

" Use astyle by default for formatting if it exists
if executable("astyle")
  call InitializeFormatProgram("astyle")
endif

" Disable continuation commenting
if has("autocmd") 
  augroup comment_format
    autocmd!
    autocmd FileType * set formatoptions-=cro
  augroup END
endif 

" For other file types, use other format programs
if has("autocmd") 
  " set formatprg for xml files
  if executable("xmllint")
    augroup xml_format
      autocmd!
      autocmd BufEnter *.xml,*.xsd call SetFormatProgram("xmllint --format -")
    augroup END
  endif

  " set formatprg for java files
  if executable("astyle")
    augroup java_format
      autocmd!
      autocmd BufEnter *.java call SetFormatProgram("astyle --mode=java")
    augroup END
  endif

  " restore formatprg when leaving a buffer
  augroup restore_format
    autocmd!
    autocmd BufLeave * call RestoreFormatProgram()
  augroup END
endif

" -------------------------------
" Configure Python Instance
" -------------------------------

if has("python") && executable("python")
  python << 
try:
    from math import * 
    import vim
    import sys
except ImportError:
    pass

endif

" -------------------------------
" PATH Utilities
" -------------------------------

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

" -------------------------------
" Cscope Functions
" -------------------------------

" Attempts to automatically find a cscope database to use
function! CscopeAutoAdd()
    " add any database in current directory
    let db = findfile('cscope.out', '.;')
    if !empty(db)
        silent cscope reset
        silent! execute 'cscope add' db
        " else add database pointed to by environment
    elseif !empty($CSCOPE_DB)
        silent cscope reset
        silent! execute 'cscope add' $CSCOPE_DB
    endif
endfunction

" Attempts to add a cscope database for each path element
function! CscopeAddPath()
    ForEachPath("cscope add %s %s")
    cscope reset
endfunction

" Executes a cscope rescan on the current directory recursively
function! CscopeRescan()
    let ft = &filetype

    if ft == "java"
        silent !find * -type f | grep "\.java$" > cscope.files
    endif

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

    cscope reset
    redraw!
endfunction

" Rescans the cscope database in the current directory
function! CscopeRescanRecurse()
    call CscopeRescan()
    cscope reset
    redraw!
endfunction

" -------------------------------
" Cscope Settings
" -------------------------------

if has("cscope") && executable("cscope")
    set nocscopeverbose
    set csto=0 " Try cscope first in tag search
    set cst " Add cscope to tag search
    set cscopequickfix=s-,c-,d-,i-,t-,e-,g-
    call CscopeAutoAdd()
endif

" -------------------------------
" Arbitrary Python Math
" -------------------------------

" Solves the given mathemical expression and returns the result
function! EvalMathExpression(exp) 
    execute "python sys.argv = [\"" . a:exp . "\"]"
    python sys.argv[0] = eval(sys.argv[0])
    python vim.command("let out = \"" + str(sys.argv[0]) + "\"")
    return out
endfunction

" -------------------------------
" Buffer Management Functions
" -------------------------------

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

" -------------------------------
" Grep Functions
" -------------------------------

" Greps recursively from the current working directory
function! GrepRecurse(arg)
    silent! execute "silent! grep! -r """ . shellescape(getreg(a:arg)) . """"
    cw
    redraw!
endfunction

" Greps recursively from the current working directory
function! GrepRecurseRegister()
    silent! execute "silent! grep! -r """ . shellescape(getreg(v:register)) . """"
    cw
    redraw!
endfunction

" Greps in the current window
function! GrepCurrentRegister()
    silent! execute "silent! grep! """ . shellescape(getreg(v:register)) . """ % "
    cw
    redraw!
endfunction

" Greps in all windows
function! GrepWindowRegister() 
    call ClearCw()
    windo silent! execute "silent! grepadd! """ . shellescape(getreg(v:register)) . """ %"
    cw
    redraw!
endfunction

" Greps recursively for all directories in the path
function! GrepPathRegister()
    let plist = GetPathString()
    silent! execute "silent! grep! -r """ . shellescape(getreg(v:register)) . """ " . plist
    cw
    redraw!
endfunction

" -------------------------------
" Window functions
" -------------------------------

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

" -------------------------------
" Operator Wrapping Functions
" -------------------------------

" Used as an operator function with a callback. Passes arguments via the current register.
function! RegisterOperatorWrapper(type, callback) 
    let sel_save = &selection
    let &selection = "inclusive"
    let reg = v:register
    let reg_save = getreg(reg)

    if a:type ==# 'v' || a:type ==# 'V' || a:type == ''
        normal! gvy
    elseif a:type == 'line'
        normal! `[V`]y
    elseif a:type == 'block'
        normal! `[\<C-V>`]y
    else
        normal! `[v`]y
    endif

    silent execute a:callback

    if a:type ==# 'v' || a:type ==# 'V' || a:type == ''
        call setreg(reg, getreg(reg), a:type)
        normal! gvp
    elseif a:type == 'line'
        normal! `[V`]p
    elseif a:type == 'block' 
        normal! `[\<C-V>`]p
    else
        normal! `[v`]p
    endif

    let &selection = sel_save
    call setreg(reg, reg_save)
endfunction

" Wraps operator functions that rely on simple input text
function! OperatorWrapper(type, callback)
    let sel_save = &selection
    let &selection = "inclusive"
    let reg_save = getreg(v:register)

    if a:type ==# 'v' || a:type ==# 'V' || a:type == ''
        normal! gvy
    elseif a:type == 'line'
        normal! `[V`]y
    elseif a:type == 'block' 
        normal! `[\<C-V>`]y
    else
        normal! `[v`]y
    endif

    silent execute a:callback

    let &selection = sel_save
    call setreg(v:register, reg_save)
endfunction

" -------------------------------
" URL Encoding Functions
" -------------------------------

let g:urlRanges = [[0, 32], [34, 38], [43, 44], [47, 47], [58, 64], [91, 94], [96, 96], [123, 127], [128, 255]]
let g:urlRangeCount = len(urlRanges)

" Does a binary search for whether or not the current character is in the URL encoding range
function! UrlEncodeCharInternal(charByte, lower, upper)
    let idx = a:lower + (a:upper - a:lower) / 2

    if a:lower > a:upper 
        return 0
    endif

    if a:charByte < g:urlRanges[idx][0] 
        return UrlEncodeCharInternal(a:charByte, a:lower, idx - 1)
    elseif a:charByte > g:urlRanges[idx][1] 
        return UrlEncodeCharInternal(a:charByte, idx + 1, a:upper)
    endif

    return 1
endfunction

" Returns whether or not a character needs to be URL encoded
function! UrlEncodeChar(charByte)
    return UrlEncodeCharInternal(a:charByte, 0, g:urlRangeCount - 1)
endfunction

" URL Encodes the current register
function! UrlEncodeRegister()
    let newStr = ""
    let i = 0
    let reg_val = getreg(v:register)

    while 1
        let newChar = reg_val[i]
        let byteVal = char2nr(newChar)

        if byteVal == 0
            break
        endif

        if UrlEncodeChar(byteVal)  
            let newChar = "%" . printf('%02X', byteVal)
        endif

        let newStr .= newChar
        let i += 1
    endwhile

    call setreg(v:register, newStr)
endfunction

" URL decodes the current register
function! UrlDecodeRegister()
    let newStr = ""
    let i = 0
    let reg_val = getreg(v:register)

    while 1
        let newChar = reg_val[i]
        let byteVal = char2nr(newChar)

        if byteVal == 0
            break
        endif

        if newChar == "%"
            let newChar = nr2char(str2nr(reg_val[i+1:i+2], 16))
            let i += 2
        endif

        let newStr .= newChar
        let i += 1
    endwhile

    call setreg(v:register, newStr)
endfunction

" -------------------------------
" Operator Functions
" -------------------------------

function! GrepWindowOperator(type) 
  call OperatorWrapper(a:type, "call GrepWindowRegister()")
endfunction

function! GrepRecurseOperator(type)
  call OperatorWrapper(a:type, "call GrepRecurseRegister()")
endfunction

function! GrepCurrentOperator(type)
  call OperatorWrapper(a:type, "call GrepCurrentRegister()")
endfunction

function! GrepPathOperator(type)
  call OperatorWrapper(a:type, "call GrepPathRegister()")
endfunction

function! UrlEncodeOperator(type)
  call RegisterOperatorWrapper(a:type, "call UrlEncodeRegister()")
endfunction

function! UrlDecodeOperator(type)
  call RegisterOperatorWrapper(a:type, "call UrlDecodeRegister()")
endfunction

function! ExternalOperator(type)
  call RegisterOperatorWrapper(a:type, "call ExternalRegister()")
endfunction

function! SortStringLengthOperator(type)
    call RegisterOperatorWrapper(a:type, "call SortStringLengthRegister()")
endfunction

function! ReverseSortStringLengthOperator(type)
    call RegisterOperatorWrapper(a:type, "call ReverseSortStringLengthRegister()")
endfunction

function! ShuffleOperator(type)
    call RegisterOperatorWrapper(a:type, "call ShuffleRegister()")
endfunction

function! SequenceOperator(type)
    call RegisterOperatorWrapper(a:type, "call SequenceRegister()")
endfunction

function! ComplimentOperator(type)
    call RegisterOperatorWrapper(a:type, "call ComplimentRegister()")
endfunction

function! SymmetricDifferenceOperator(type)
    call RegisterOperatorWrapper(a:type, "call SymmetricDifferenceRegister()")
endfunction

function! SplitOperator(type)
    call RegisterOperatorWrapper(a:type, "call SplitRegister()")
endfunction

function! JoinOperator(type)
    call RegisterOperatorWrapper(a:type, "call JoinRegister()")
endfunction

function! JoinSeparatorOperator(type)
    call RegisterOperatorWrapper(a:type, "call JoinSeparatorRegister()")
endfunction

function! UniqueOperator(type)
    call RegisterOperatorWrapper(a:type, "call UniqueRegister()")
endfunction

function! DuplicateOperator(type)
    call RegisterOperatorWrapper(a:type, "call DuplicateRegister()")
endfunction

function! SortOperator(type)
    call RegisterOperatorWrapper(a:type, "call SortRegister()")
endfunction

function! SortReverseOperator(type)
    call RegisterOperatorWrapper(a:type, "call SortReverseRegister()")
endfunction

function! TopologicalSortOperator()
    call RegisterOperatorWrapper(a:type, "call TopologicalSortRegister()")
endfunction

function! MathExpressionOperator(type) 
    call RegisterOperatorWrapper(a:type, "call MathExpressionRegister()")
endfunction

function! Base64Operator(type) 
    call RegisterOperatorWrapper(a:type, "call Base64Register()")
endfunction

function! Base64DecodeOperator(type) 
    call RegisterOperatorWrapper(a:type, "call Base64DecodeRegister()")
endfunction

function! Md5Operator(type) 
    call RegisterOperatorWrapper(a:type, "call Md5Register()")
endfunction

function! CrcOperator(type) 
    call RegisterOperatorWrapper(a:type, "call CrcRegister()")
endfunction

function! CppFilterOperator(type) 
    call RegisterOperatorWrapper(a:type, "call CppFilterRegister()")
endfunction

function! UnixToDosOperator(type) 
    call RegisterOperatorWrapper(a:type, "call UnixToDosRegister()")
endfunction

function! TitleCaseOperator(type) 
    call RegisterOperatorWrapper(a:type, "call TitleCaseRegister()")
endfunction

function! TableOperator(type) 
    call RegisterOperatorWrapper(a:type, "call TableRegister()")
endfunction

function! DosToUnixOperator(type) 
    call RegisterOperatorWrapper(a:type, "call DosToUnixRegister()")
endfunction

function! MacToUnixOperator(type) 
    call RegisterOperatorWrapper(a:type, "call MacToUnixRegister()")
endfunction

function! UnixToMacOperator(type) 
    call RegisterOperatorWrapper(a:type, "call UnixToMacRegister()")
endfunction

function! TableSeparatorOperator(type) 
    call RegisterOperatorWrapper(a:type, "call TableSeparatorRegister()")
endfunction

function! SubstituteRegisterOperator(type) 
    call RegisterOperatorWrapper(a:type, "call SubstituteRegisterRegister()")
endfunction

function! SubstituteOperator(type) 
    call RegisterOperatorWrapper(a:type, "call SubstituteRegister()")
endfunction

function! Sha256Operator(type)
  call RegisterOperatorWrapper(a:type, "call Sha256Register()")
endfunction

" -------------------------------
" Set Function Mappings
" -------------------------------

" Performs a topological sort
function! TopologicalSortRegister()
    call setreg(v:register, system("tsort", getreg(v:register)))
endfunction

" Gets the compliment of two sets
function! ComplimentRegister()
    let A = uniq(sort(split(getreg(v:register), "\n")))
    let B = uniq(sort(split(getreg(input("Enter register: ")), "\n")))
    call filter(A, 'index(B, v:val) < 0')
    call setreg(v:register, join(A, "\n"))
endfunction

" Gets the symmetric difference of two sets
function! SymmetricDifferenceRegister()
    call setreg(v:register, join(uniq(sort(split(getreg(v:register), "\n")), "DuplicateBlockFunction"), "\n"))
endfunction

" Used for sorting based on string length
function! LengthFunction(arg1, arg2)
    return strlen(a:arg1) - strlen(a:arg2)
endfunction

" Sorts strings based on their length
function! SortStringLengthRegister()
    call setreg(v:register, join(sort(split(getreg(v:register), "\n"), "LengthFunction"), "\n"))
endfunction

" Reverse sorts strings based on their length
function! ReverseSortStringLengthRegister()
    call setreg(v:register, join(reverse(sort(split(getreg(v:register), "\n"), "LengthFunction")), "\n"))
endfunction

" Shuffle the input lines
function! ShuffleRegister()
    call setreg(v:register, system("shuf", getreg(v:register)))
endfunction

" Replace input lines with a sequence of numbers
function! SequenceRegister()
    let linecount=len(split(getreg(v:register), "\n"))
    call setreg(v:register, system('seq ' . linecount, getreg(v:register)))
endfunction

" Joins newline separated values with spaces
function! JoinRegister()
    call setreg(v:register, join(split(getreg(v:register), "\n"), " "))
endfunction

" Joins newline separated values with user specified delimiter
function! JoinSeparatorRegister()
    let delimiter = input("Enter delimiter: ")
    call setreg(v:register, join(split(getreg(v:register), "\n"), delimiter))
endfunction

" Removes duplicates
function! UniqueRegister()
    call setreg(v:register, join(uniq(sort(split(getreg(v:register), "\n"))), "\n"))
endfunction

" Checks if adjacent values are the same
function! DuplicateFunction(arg1, arg2) 
    return a:arg1 ==# a:arg2 
endfunction

" Finds blocks of adjacent values that are the same
function! DuplicateBlockFunction(arg1, arg2)
    if a:arg1 ==# a:arg2 || a:arg1 ==# g:DuplicateValue 
        let g:DuplicateValue = a:arg1
        return 0 
    endif
    return 1
endfunction

" Removes unique values (set intersection) 
" Also: 
" join <(sort -n A) <(sort -n B)
" sort -n A B | uniq -d
" grep -xF -f A B
" comm -12 <(sort -n A) <(sort -n B)
function! DuplicateRegister()
    let g:DuplicateValue = ""
    call setreg(v:register, join(uniq(uniq(sort(add(split(getreg(v:register), "\n"), "")), "DuplicateFunction")), "\n"))
endfunction

" Sorts the given text
function! SortRegister()
    call setreg(v:register, join(sort(split(getreg(v:register), "\n")), "\n"))
endfunction

" Reverse sorts the given text
function! SortReverseRegister()
    call setreg(v:register, join(reverse(sort(split(getreg(v:register), "\n"))), "\n"))
endfunction

" -------------------------------
" Text Function Mappings
" -------------------------------

" Creates SHA256 hash
function! Sha256Register()
    call setreg(v:register, sha256(getreg(v:register)))
endfunction

" Splits up values
function! SplitRegister()
    let delimiter = input("Enter delimiter: ")
    call setreg(v:register, join(split(getreg(v:register), delimiter), "\n"))
endfunction

" Executes and replaces given commands
function! ExternalRegister()
    call setreg(v:register, system(&shell, getreg(v:register)))
    call setreg(v:register, substitute(getreg(v:register), "^\n", "", "") )
    call setreg(v:register, substitute(getreg(v:register), "\n$", "", "") )
endfunction

" Performs a regex substitution on the given text
function! SubstituteRegisterRegister()
    let pat = getreg(input("Enter pattern register: "))
    let sub = getreg(input("Enter substitution register: "))
    let flags = input("Enter flags: ")
    let list = split(getreg(v:register), "\n")
    let size = len(list)
    let i = 0 
    while i < size
        let list[i] = substitute(list[i], pat, sub, flags)
        let i += 1
    endwhile
    call setreg(v:register, join(list, "\n"))
endfunction

" Performs a regex substitution on the given text
function! SubstituteRegister()
    let pat = input("Enter pattern: ")
    let sub = input("Enter substitution: ")
    let flags = input("Enter flags: ")
    let list = split(getreg(v:register), "\n")
    let size = len(list)
    let i = 0 
    while i < size
        let list[i] = substitute(list[i], pat, sub, flags)
        let i += 1
    endwhile
    call setreg(v:register, join(list, "\n"))
endfunction

" Evaluates mathematical expressions
function! MathExpressionRegister() 
    call setreg(v:register, EvalMathExpression(getreg(v:register)))
endfunction

" Makes text title case
function! TitleCaseRegister()
    call setreg(v:register, substitute(getreg(v:register), "\\v<(.)(\\w*)>", "\\u\\1\\L\\2", "g") )
endfunction

" Creates a table from space separated arguments
function! TableRegister()
    call setreg(v:register, system("column -t", getreg(v:register)))
endfunction

" Creates a table from comma separated arguments
function! TableSeparatorRegister()
    let delimiter = input("Enter delimiter: ")
    call setreg(v:register, system("column -s" . shellescape(delimiter) ." -t", getreg(v:register)))
endfunction

" Converts unix text to mac
function! UnixToMacRegister()
    call setreg(v:register, system("unix2mac -f", getreg(v:register)))
endfunction

" Converts mac text to unix
function! MacToUnixRegister()
    call setreg(v:register, system("mac2unix -f", getreg(v:register)))
endfunction

" Converts dos text to unix
function! DosToUnixRegister()
    call setreg(v:register, system("dos2unix -f", getreg(v:register)))
endfunction

" Converts unix text to dos
function! UnixToDosRegister()
    call setreg(v:register, system("unix2dos -f", getreg(v:register)))
endfunction

" Converts cpp name mangled strings to their pretty counterparts
function! CppFilterRegister()
    call setreg(v:register, system("c++filt", getreg(v:register)))
endfunction

" Performs crc32 on selected text
function! CrcRegister() 
    call setreg(v:register, system("cksum", getreg(v:register)))
    call setreg(v:register, substitute(getreg(v:register), "\\n", "", "g"))
    call setreg(v:register, substitute(getreg(v:register), " .*", "", "g"))
endfunction

" Performs md5 on selected text
function! Md5Register() 
    call setreg(v:register, system("md5sum", getreg(v:register)))
    call setreg(v:register, substitute(getreg(v:register), "\\n", "", "g"))
    call setreg(v:register, substitute(getreg(v:register), " .*", "", "g"))
endfunction

" Base64 encodes text
function! Base64Register() 
    call setreg(v:register, system("base64", getreg(v:register)))
    call setreg(v:register, substitute(getreg(v:register), "\\n", "", "g"))
endfunction

" Base64 decodes text
function! Base64DecodeRegister() 
    call setreg(v:register, system("base64 -d", getreg(v:register)))
    call setreg(v:register, substitute(getreg(v:register), "\\n", "", "g"))
endfunction

" -------------------------------
" Miscellaneous Mappings
" -------------------------------

" Leader
let mapleader="\\"

" Escape
inoremap jk <Esc>

" Reload .vimrc
nnoremap <leader>lg :source ~/.vimrc<CR>
nnoremap <leader>ll :source ./.vimrc<CR>

" Build
nnoremap <leader>k :make<CR>

" Make Y behave like other capitals
nnoremap Y y$

" Make command mode work like readline
cnoremap <C-a> <Home>

" -------------------------------
" Window Navigation Mappings
" -------------------------------

" Navigate to Previous File
nnoremap <leader><C-O> :ed#<CR>

" Circular Window Navigation
nnoremap <tab> <c-w>w
nnoremap <S-tab> <c-w>W

" Quick Window Navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" -------------------------------
" Cscope Mappings
" -------------------------------

nnoremap <C-\>r :call CscopeRescanRecurse()<CR>
nnoremap <C-\>p :call CscopeRescanAll()<CR>

nnoremap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
nnoremap <C-\>i :cs find i <C-R>=expand("<cfile>")<CR><CR>
nnoremap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>

nnoremap <C-@>s :scs find s <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-@>g :scs find g <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-@>c :scs find c <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-@>t :scs find t <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-@>e :scs find e <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-@>f :scs find f <C-R>=expand("<cfile>")<CR><CR>
nnoremap <C-@>i :scs find i <C-R>=expand("<cfile>")<CR><CR>
nnoremap <C-@>d :scs find d <C-R>=expand("<cword>")<CR><CR>

nnoremap <C-@><C-@>s :vert scs find s <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-@><C-@>g :vert scs find g <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-@><C-@>c :vert scs find c <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-@><C-@>t :vert scs find t <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-@><C-@>e :vert scs find e <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-@><C-@>f :vert scs find f <C-R>=expand("<cfile>")<CR><CR>
nnoremap <C-@><C-@>i :vert scs find i <C-R>=expand("<cfile>")<CR><CR>
nnoremap <C-@><C-@>d :vert scs find d <C-R>=expand("<cword>")<CR><CR>

" -------------------------------
" Window Mappings
" -------------------------------

nnoremap <leader>wn :NERDTreeToggle<CR>
nnoremap <leader>wt :TagbarToggle<CR>
nnoremap <leader>ws :TScratch<CR>
nnoremap <leader>wg :GundoToggle<CR>
nnoremap <leader>we :CCTreeWindowToggle<CR>
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
nnoremap <leader>wz :set spell!<CR> 
set pastetoggle=<leader>wp

" -------------------------------
" Grep Operator Mappings
" -------------------------------

map <leader>gp <Plug>(operator-grep-path)
call operator#user#define('grep-path', 'GrepPathOperator')

map <leader>gr <Plug>(operator-grep-recursive)
call operator#user#define('grep-recursive', 'GrepRecurseOperator')

map <leader>gc <Plug>(operator-grep-current)
call operator#user#define('grep-current', 'GrepCurrentOperator')

map <leader>gb <Plug>(operator-grep-buffer)
call operator#user#define('grep-buffer', 'GrepBufferOperator')

map <leader>gw <Plug>(operator-grep-window)
call operator#user#define('grep-window', 'GrepWindowOperator')

" -------------------------------
" Text Transformation Mappings
" -------------------------------

map <leader>tud <Plug>(operator-unix-to-dos)
call operator#user#define('unix-to-dos', 'UnixToDosOperator')

map <leader>tdu <Plug>(operator-dos-to-unix)
call operator#user#define('dos-to-unix', 'DosToUnixOperator')

map <leader>tmu <Plug>(operator-mac-to-unix)
call operator#user#define('mac-to-unix', 'MacToUnixOperator')

map <leader>tum <Plug>(operator-unix-to-mac)
call operator#user#define('unix-to-mac', 'UnixToMacOperator')

map <leader>tb <Plug>(operator-base64)
call operator#user#define('base64', 'Base64Operator')

map <leader>tB <Plug>(operator-base64-decode)
call operator#user#define('base64-decode', 'Base64DecodeOperator')

map <leader>t2 <Plug>(operator-sha256)
call operator#user#define('sha256', 'Sha256Operator')

map <leader>t5 <Plug>(operator-md5)
call operator#user#define('md5', 'Md5Operator')

map <leader>tk <Plug>(operator-crc)
call operator#user#define('crc', 'CrcOperator')

map <leader>tp <Plug>(operator-cpp-filter)
call operator#user#define('cpp-filter', 'CppFilterOperator')

map <leader>ti <Plug>(operator-title-case)
call operator#user#define('title-case', 'TitleCaseOperator')

map <leader>tt <Plug>(operator-table)
call operator#user#define('table', 'TableOperator')

map <leader>tT <Plug>(operator-table-separator)
call operator#user#define('table-separator', 'TableSeparatorOperator')

map <leader>ts <Plug>(operator-substitute)
call operator#user#define('substitute', 'SubstituteOperator')

map <leader>tS <Plug>(operator-substitute-register)
call operator#user#define('substitute-register', 'SubstituteRegisterOperator')

map <leader>tl <Plug>(operator-split)
call operator#user#define('split', 'SplitOperator')

map <leader>tj <Plug>(operator-join)
call operator#user#define('join', 'JoinOperator')

map <leader>tJ <Plug>(operator-join-separator)
call operator#user#define('join-separator', 'JoinSeparatorOperator')

map <leader>tr <Plug>(operator-url-encode)
call operator#user#define('url-encode', 'UrlEncodeOperator')

map <leader>tR <Plug>(operator-url-decode)
call operator#user#define('url-decode', 'UrlDecodeOperator')

map <leader>! <Plug>(operator-external)
call operator#user#define('external', 'ExternalOperator')

map <leader>m <Plug>(operator-math)
call operator#user#define('math', 'MathExpressionOperator')

map <leader>p <Plug>(operator-replace)

vmap <leader>a <Plug>(EasyAlign)
nmap <leader>a <Plug>(EasyAlign)

" -------------------------------
" Set Operation Mappings
" -------------------------------

map <leader>sP <Plug>(operator-topsort)
call operator#user#define('topsort', 'TopologicalSortOperator')

map <leader>sr <Plug>(operator-sort)
call operator#user#define('sort', 'SortOperator')

map <leader>sR <Plug>(operator-sort-reverse)
call operator#user#define('sort-reverse', 'SortReverseOperator')

map <leader>su <Plug>(operator-unique)
call operator#user#define('unique', 'UniqueOperator')

map <leader>sU <Plug>(operator-duplicate)
call operator#user#define('duplicate', 'DuplicateOperator')

map <leader>s- <Plug>(operator-compliment)
call operator#user#define('compliment', 'ComplimentOperator')

map <leader>s+ <Plug>(operator-symmetric-difference)
call operator#user#define('symmetric-difference', 'SymmetricDifferenceOperator')

map <leader>se <Plug>(operator-sort-string-length)
call operator#user#define('sort-string-length', 'SortStringLengthOperator')

map <leader>sE <Plug>(operator-reverse-sort-string-length)
call operator#user#define('reverse-sort-string-length', 'ReverseSortStringLengthOperator')

map <leader>sf <Plug>(operator-shuffle)
call operator#user#define('shuffle', 'ShuffleOperator')

map <leader>sq <Plug>(operator-sequence)
call operator#user#define('sequence', 'SequenceOperator')

" -------------------------------
" .vimrc Reload Mappings
" -------------------------------

nnoremap <leader>lg :source ~/.vimrc<CR>
nnoremap <leader>ll :source ./.vimrc<CR>

" -------------------------------
" Local .vimrc Settings
" -------------------------------

if filereadable(glob("~/.local/.vimrc"))
    source ~/.local/.vimrc
endif

