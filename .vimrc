
" -------------------------------
" TODO list
" -------------------------------

" table mode
" refactoring operations
" set operations: mean, median, mode, sum
" multiroot operations (rsync svn git sed cscope)
" consider modifying cscope scan to always pull applicable file types into cscope.files
" left/right expression text object
" help: msdn
" text transforms: c escaped string, html / xml entities

" -------------------------------
" plugin setup
" -------------------------------

let s:my_vim_dir=fnamemodify(resolve(expand('<sfile>')), ':h')
call plug#begin(s:my_vim_dir . '/bundle')

Plug 'a-vim', {'on': [ 'A', 'AS', 'AV', 'AT', 'AN', 'IH', 'IHS', 'IHT', 'IHN' ] }
Plug 'bufexplorer'
Plug 'camel_case_motion'
Plug 'cctree' , { 'on': 'CCTreeLoadDB' }
Plug 'cisco-ios'
Plug 'cmake' , { 'for': 'cmake' }
Plug 'dispatch'
Plug 'dosbatch' , { 'for': 'dosbatch' }
Plug 'doxygen_toolkit' , { 'on': ['Dox', 'DoxAuthor'] }
Plug 'easy-align' , { 'on': '<Plug>(EasyAlign)' }
Plug 'gundo' , { 'on': 'GundoToggle' }
Plug 'js-indent' , { 'for': 'javascript' }
Plug 'js-syntax' , { 'for': 'javascript' }
Plug 'latexbox'
Plug 'matchit'
Plug 'nerdtree' , { 'on':  'NERDTreeToggle' }
Plug 'obsession'
Plug 'operator-replace'
Plug 'operator-user'
Plug 'ps1'
Plug 'python-mode' , { 'for':  'python' }
Plug 'snipmate'
Plug 'startify'
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
Plug 'viewdoc'
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
" general settings
" -------------------------------

set nocompatible
colors evening
set bs=2
set expandtab
set history=1000
set laststatus=2
set scrolloff=5
set lazyredraw
set mouse=""  " no mouse
set noincsearch
set nojoinspaces
set nolinebreak
set noshowmatch
set nowrap
set number
set smartcase
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
" indentation settings
" -------------------------------

set autoindent
set softtabstop=4
set shiftwidth=4
set tabstop=4
set cinoptions+=g0  " access specifiers left justified
set cinoptions+=N-s " namespace content not indented
set cinoptions+=:0  " case labels not indented

" -------------------------------
" ignorecase
" -------------------------------

set ignorecase

if exists("&wildignorecase")
    set wildignorecase
endif

if exists("&fileignorecase")
    set fileignorecase
endif

" -------------------------------
" compiler settings
" -------------------------------

" gcc ld linker errors
set errorformat+=%f:\(.text%*[^\ ]%m

" -------------------------------
" grep settings
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
" completion settings
" -------------------------------

if has('insert_expand')
    " don't scan includes for completion (slow)
    set complete-=i

    " don't use the preview window
    set completeopt=menu,menuone
endif

" -------------------------------
" cursor settings
" -------------------------------

highlight CursorLine cterm=reverse term=reverse gui=reverse
highlight StatusLineNC ctermfg=Black ctermbg=DarkCyan guibg=DarkCyan cterm=none term=none gui=none
highlight StatusLine ctermfg=Black ctermbg=DarkCyan guibg=DarkCyan cterm=none term=none gui=none
highlight VertSplit ctermfg=Black ctermbg=DarkCyan guibg=DarkCyan cterm=none term=none gui=none
set fillchars=vert:\|,fold:-,stl:\-,stlnc:\ 
set cursorline

" -------------------------------
" directory .vimrc settings
" -------------------------------

set exrc
set secure

" -------------------------------
" persistent undo settings
" -------------------------------

if exists('+undofile')
    set undofile
endif

" -------------------------------
" youcompleteme settings
" -------------------------------

" auto-load ycm config file
let g:ycm_confirm_extra_conf = 0
let g:ycm_show_diagnostics_ui = 0

" CMAKE / YCM integration
" $ cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
" $ echo "compilation_database_folder = 'path/to/compile_commands.json'" >> .ycm_extra_conf.py

" -------------------------------
" syntastic settings
" -------------------------------

let g:syntastic_check_on_open = 0

" -------------------------------
" ultisnips settings
" -------------------------------

" deal with interactions between ycm and ultisnips
let g:ycm_key_list_select_completion = ['<C-TAB>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-S-TAB>', '<Up>']

" -------------------------------
" easy align settings
" -------------------------------

" add some delimiters
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
" eclim settings
" -------------------------------

" enable eclim completion only on java files
if has("autocmd") 
    augroup eclim_java_completion
        autocmd!
        autocmd BufEnter *.java let g:EclimCompletionMethod = 'omnifunc'
        autocmd BufLeave *.java unlet g:EclimCompletionMethod
    augroup END
endif 

" -------------------------------
" viewdoc settings
" -------------------------------

" open docs in a new window
let g:viewdoc_open='topleft new'

" disable abbreviations
let g:no_viewdoc_abbrev=1

" don't open anything if the term is not found
let g:viewdoc_openempty=0

" enable documentation for other filetypes
let g:ViewDoc_cmake=[ 'ViewDoc_help_custom', 'ViewDoc_DEFAULT' ]
let g:ViewDoc_css=[ 'ViewDoc_help_custom' ]
let g:ViewDoc_tex=[ 'ViewDoc_help_custom' ]
let g:ViewDoc_c=[ 'ViewDoc_DEFAULT', 'ViewDoc_help_custom' ]
let g:ViewDoc_cpp=[ 'ViewDoc_DEFAULT', 'ViewDoc_help_custom' ]

let g:asm_help=[ 'ViewDoc_help_custom', 'ViewDoc_DEFAULT' ]
let g:ViewDoc_asm=g:asm_help
let g:ViewDoc_fasm=g:asm_help
let g:ViewDoc_nasm=g:asm_help
let g:ViewDoc_tasm=g:asm_help
let g:ViewDoc_masm=g:asm_help

if executable("cmd")
    " use the dos help command
    function! s:ViewDoc_doshelp(topic, filetype, synid, ctx)
        let tmp_topic=shellescape(a:topic,1)
        let output=system('cmd /C help '.tmp_topic)
        if match(output, "This command is not supported by the help utility") != -1
            return {}
        else 
            return { 'cmd': 'cmd /C help '.tmp_topic,
                        \ 'ft':	'dosbatch',
                        \ }
        endif
    endfunction

    " define a custom handler for dosbatch
    let g:ViewDoc_dosbatch=[ function('s:ViewDoc_doshelp') ]
endif

" define a custom help handler for udev files
function! s:ViewDoc_udev(topic, filetype, synid, ctx)
    return {
                \'cmd':    'man udev',
                \'ft':     'man',
                \'search': '^[ ]\+' . a:topic . '\>',
                \}
endfunction
let g:ViewDoc_udevconf=[ function('s:ViewDoc_udev') ]
let g:ViewDoc_udevrules=[ function('s:ViewDoc_udev') ]
let g:ViewDoc_udevperm=[ function('s:ViewDoc_udev') ]

" define a custom help handler for dnsmasq files
function! s:ViewDoc_dnsmasq(topic, filetype, synid, ctx)
    return {
                \'cmd':    'man dnsmasq',
                \'ft':     'man',
                \'search': a:topic,
                \}
endfunction
let g:ViewDoc_dnsmasq=[ function('s:ViewDoc_dnsmasq') ]

" define a custom help handler for sysctl files
function! s:ViewDoc_sysctl(topic, filetype, synid, ctx)
    return {
                \'cmd':    'sysctl --all',
                \'ft':     'sysctl',
                \'search': a:topic,
                \}
endfunction
let g:ViewDoc_sysctl=[ function('s:ViewDoc_sysctl') ]

" define a custom help handler for samba files
function! s:ViewDoc_samba(topic, filetype, synid, ctx)
    return {
                \'cmd':    'man smb.conf',
                \'ft':     'man',
                \'search': '^[ ]\+' . a:topic . '\>',
                \}
endfunction
let g:ViewDoc_samba=[ function('s:ViewDoc_samba') ]

" define a custom help handler for readline files
function! s:ViewDoc_readline(topic, filetype, synid, ctx)
    return {
                \'cmd':    'man readline',
                \'ft':     'man',
                \'search': '^[ ]\+' . a:topic . '\>',
                \}
endfunction
let g:ViewDoc_readline=[ function('s:ViewDoc_readline') ]

" define a custom help handler for pamconf files
function! s:ViewDoc_pamconf(topic, filetype, synid, ctx)
    return {
                \'cmd':    'man pam.conf',
                \'ft':     'man',
                \'search': '^[ ]\+' . a:topic . '\>',
                \}
endfunction
let g:ViewDoc_pamconf=[ function('s:ViewDoc_pamconf') ]

" define a custom help handler for xf86conf files
function! s:ViewDoc_xf86conf(topic, filetype, synid, ctx)
    return {
                \'cmd':    'man xorg.conf',
                \'ft':     'man',
                \'search': '^[ ]\+' . a:topic . '\>',
                \}
endfunction
let g:ViewDoc_xf86conf=[ function('s:ViewDoc_xf86conf') ]

" define a custom help handler for ldap.conf files
function! s:ViewDoc_ldapconf(topic, filetype, synid, ctx)
    return {
                \'cmd':    'man ldap.conf',
                \'ft':     'man',
                \'search': '^[ ]\+' . a:topic . '\>',
                \}
endfunction
let g:ViewDoc_ldapconf=[ function('s:ViewDoc_ldapconf') ]

" define a custom help handler for resolv.conf files
function! s:ViewDoc_resolv(topic, filetype, synid, ctx)
    return {
                \'cmd':    'man resolv.conf',
                \'ft':     'man',
                \'search': '^[ ]\+' . a:topic . '\>',
                \}
endfunction
let g:ViewDoc_resolv=[ function('s:ViewDoc_resolv') ]

" define a custom help handler for expect files
function! s:ViewDoc_expect(topic, filetype, synid, ctx)
    return {
                \'cmd':    'man expect',
                \'ft':     'man',
                \'search': '^[ ]\+' . a:topic . '\>',
                \}
endfunction
let g:ViewDoc_expect=[ function('s:ViewDoc_expect') ]

" define a custom help handler for terminfo files
function! s:ViewDoc_terminfo(topic, filetype, synid, ctx)
    return {
                \'cmd':    'man terminfo',
                \'ft':     'man',
                \'search': '^[ ]\+' . a:topic . '\>',
                \}
endfunction
let g:ViewDoc_terminfo=[ function('s:ViewDoc_terminfo') ]

" define a custom help handler for wget files
function! s:ViewDoc_wget(topic, filetype, synid, ctx)
    return {
                \'cmd':    'man wget',
                \'ft':     'man',
                \'search': '^[ ]\+' . a:topic . '\>',
                \}
endfunction
let g:ViewDoc_wget=[ function('s:ViewDoc_wget') ]

" define a custom help handler for gitconfig files
function! s:ViewDoc_gitconfig(topic, filetype, synid, ctx)
    return {
                \'cmd':    'man git-config',
                \'ft':     'man',
                \'search': '^[ ]\+' . a:topic . '\>',
                \}
endfunction
let g:ViewDoc_gitconfig=[ function('s:ViewDoc_gitconfig') ]

" define a custom help handler for screenrc files
function! s:ViewDoc_screen(topic, filetype, synid, ctx)
    return {
                \'cmd':    'man screen',
                \'ft':     'man',
                \'search': '^[ ]\+' . a:topic . '\>',
                \}
endfunction
let g:ViewDoc_screen=[ function('s:ViewDoc_screen') ]

" define a custom help handler for modules files
function! s:ViewDoc_modconf(topic, filetype, synid, ctx)
    return {
                \'cmd':    'man modules',
                \'ft':     'man',
                \'search': '^[ ]\+' . a:topic . '\>',
                \}
endfunction
let g:ViewDoc_modconf=[ function('s:ViewDoc_modconf') ]

" define a custom help handler for host.conf files
function! s:ViewDoc_hostconf(topic, filetype, synid, ctx)
    return {
                \'cmd':    'man host.conf',
                \'ft':     'man',
                \'search': '^[ ]\+' . a:topic . '\>',
                \}
endfunction
let g:ViewDoc_hostconf=[ function('s:ViewDoc_hostconf') ]

" define a custom help handler for netrc files
function! s:ViewDoc_netrc(topic, filetype, synid, ctx)
    return {
                \'cmd':    'man netrc',
                \'ft':     'man',
                \'search': '^[ ]\+' . a:topic . '\>',
                \}
endfunction
let g:ViewDoc_netrc=[ function('s:ViewDoc_netrc') ]

" define a custom help handler for apt.conf files
function! s:ViewDoc_aptconf(topic, filetype, synid, ctx)
    return {
                \'cmd':    'man apt.conf',
                \'ft':     'man',
                \'search': '^[ ]\+' . a:topic . '\>',
                \}
endfunction
let g:ViewDoc_aptconf=[ function('s:ViewDoc_aptconf') ]

" define a custom help handler for services files
function! s:ViewDoc_services(topic, filetype, synid, ctx)
    return {
                \'cmd':    'man services',
                \'ft':     'man',
                \'search': '^[ ]\+' . a:topic . '\>',
                \}
endfunction
let g:ViewDoc_services=[ function('s:ViewDoc_services') ]

" define a custom help handler for upstart files
function! s:ViewDoc_upstart(topic, filetype, synid, ctx)
    return {
                \'cmd':    'man -s 5 init',
                \'ft':     'man',
                \'search': '^[ ]\+' . a:topic . '\>',
                \}
endfunction
let g:ViewDoc_upstart=[ function('s:ViewDoc_upstart') ]

" define a custom help handler for fstab files
function! s:ViewDoc_fstab(topic, filetype, synid, ctx)
    return {
                \'cmd':    'man fstab',
                \'ft':     'man',
                \}
endfunction
let g:ViewDoc_fstab=[ function('s:ViewDoc_fstab') ]

" define a custom help handler for sshconfig files
function! s:ViewDoc_sshconfig(topic, filetype, synid, ctx)
    return {
                \'cmd':    'man ssh_config',
                \'ft':     'man',
                \'search': '^[ ]\+' . a:topic . '\>',
                \}
endfunction
let g:ViewDoc_sshconfig=[ function('s:ViewDoc_sshconfig') ]

" define a custom help handler for sshdconfig files
function! s:ViewDoc_sshdconfig(topic, filetype, synid, ctx)
    return {
                \'cmd':    'man sshd_config',
                \'ft':     'man',
                \'search': '^[ ]\+' . a:topic . '\>',
                \}
endfunction
let g:ViewDoc_sshdconfig=[ function('s:ViewDoc_sshdconfig') ]

" use the info pages for gdb help searching
let g:ViewDoc_gdb=[ 'ViewDoc_search' ]
let g:ViewDocInfoIndex_gdb = '(gdb)Command and Variable Index'

if executable("hlpviewer")
    " TODO: support more than one visual studio version
    " TODO: connect up to one of the help viewers (ie. DEFAULT)

    " invoke the help viewer for visual studio
    function! s:ViewDoc_hlpviewer(topic, filetype, synid, ctx)
        return { 'cmd': 'hlpviewer /catalogName VisualStudio14 /helpQuery "method=f1&query=' . shellescape(a:topic,1) . '"' }
    endfunction
endif

" -------------------------------
" autoformat settings
" -------------------------------

" remove comment header when joining lines
if has('patch-7.3.541')
    set formatoptions+=j
endif

" disable continuation commenting
if has("autocmd") 
    augroup comment_format
        autocmd!
        autocmd FileType * set formatoptions-=cro
    augroup END
endif 

" initialize the format program dictionary
let g:format_prg={}

" clang-format support
if executable("clang-format")
    let g:format_prg['c'] = 'clang-format -style=file'
    let g:format_prg['cpp'] = 'clang-format -style=file'
    let g:format_prg['objc'] = 'clang-format -style=file'
    let g:format_prg['javascript'] = 'clang-format -style=file'
endif

" astyle support
if executable("astyle")
    let g:format_prg['c'] = 'astyle'
    let g:format_prg['cpp'] = 'astyle'
    let g:format_prg['java'] = 'astyle --mode=java'
    let g:format_prg['cs'] = 'astyle --mode=cs'
endif

" xmllint support
if executable("xmllint")
    let g:format_prg['xsd'] = 'xmllint --format -'
    let g:format_prg['xslt'] = 'xmllint --format -'
    let g:format_prg['xml'] = 'xmllint --format -'
endif

" python support
if executable("autopep8")
    let g:format_prg['python'] = 'autopep8 -'
endif

" js-beautify support
if executable("js-beautify")
    let g:format_prg['javascript'] = 'js-beautify -'
    let g:format_prg['json'] = 'js-beautify -'
endif

" jscs support
if executable("jscs")
    let g:format_prg['javascript'] = 'jscs -x'
endif

" html-beautify support
if executable("html-beautify")
    let g:format_prg['html'] = 'html-beautify -f -'
endif

" tidy support
if executable("tidy")
    let g:format_prg['html'] = 'tidy -q --show-errors 0 --show-warnings 0 --force-output --indent auto --vertical-space yes --tidy-mark no'
    let g:format_prg['xhtml'] = 'tidy -q --show-errors 0 --show-warnings 0 --force-output --indent auto --vertical-space yes --tidy-mark no'
    let g:format_prg['xml'] = 'tidy -q -xml --show-errors 0 --show-warnings 0 --force-output --indent auto --vertical-space yes --tidy-mark no'
endif

" css-beautify support
if executable("css-beautify")
    let g:format_prg['css'] = 'css-beautify -f -'
endif

" rbeautify support
if executable("rbeautify")
    let g:format_prg['ruby'] = 'rbeautify'
endif

" sets the format program a little more easily
function! SetFormatProgram(string)
   exec "set formatprg=" . substitute( a:string, " ", "\\\\ ", "g" ) 
endfunction

" gets the format program for the filetype specified
function! GetFileTypeFormatProgram(filetype)
    return get(g:format_prg, &ft, "")
endfunction

" set up auto commands to set the format program per buffer
if has("autocmd") 
    augroup auto_format
        autocmd!

        " on entering a buffer set the format program
        autocmd BufEnter * call SetFormatProgram(GetFileTypeFormatProgram(&ft))

        " if the file type of a buffer changes, change the format program
        autocmd FileType * call SetFormatProgram(GetFileTypeFormatProgram(&ft))
    augroup END
endif

" -------------------------------
" configure python instance
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
" PATH utilities
" -------------------------------

" returns a list containing strings contained in the path variable
function! GetPathList() 
    let p = &path
    return split(p, ",")
endfunction

" returns a space separated string of all elements in the path variable
function! GetPathString() 
    let plist = GetPathList()
    return join(plist, " ")
endfunction

" executes a command string for each path element, replacing all occurances of %s with the path element string
function! ForEachPath(command)
    let plist = GetPathList()
    for p in plist 
        let newCommand = substitute(a:command, "\%s", p, "g")
        execute newCommand
    endfor
endfunction

" -------------------------------
" cscope functions
" -------------------------------

" attempts to automatically find a cscope database to use
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

" attempts to add a cscope database for each path element
function! CscopeAddPath()
    ForEachPath("cscope add %s %s")
    cscope reset
endfunction

" executes a cscope rescan on the current directory recursively
function! CscopeRescan()
    let ft = &filetype

    if ft == "java"
        silent !find * -type f | grep "\.java$" > cscope.files
    endif

    silent !cscope -Rbqk
endfunction

" executes a cscope rescan on the given directory recursively
function! CscopeRescanDir(dir)
    silent! execute "cd " . a:dir
    call CscopeRescan()
    cd -
endfunction

" returns a list of connected cscope databases
function! CscopeGetDbLines()
    redir =>cslist
    silent! cscope show
    redir END
    return split(cslist, '\n')
endfunction

" returns a list of paths of connected cscope databases
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

" rescans all currently connected cscope databases for changes
function! CscopeRescanAll()
    let paths = CscopeGetDbPaths()

    for pth in paths
        call CscopeRescanDir(pth)
    endfor

    cscope reset
    redraw!
endfunction

" rescans the cscope database in the current directory
function! CscopeRescanRecurse()
    call CscopeRescan()
    cscope reset
    redraw!
endfunction

" -------------------------------
" cscope settings
" -------------------------------

if has("cscope") && executable("cscope")
    set nocscopeverbose
    set csto=0 " Try cscope first in tag search
    set cst " Add cscope to tag search
    set cscopequickfix=s-,c-,d-,i-,t-,e-,g-
    call CscopeAutoAdd()
endif

" -------------------------------
" arbitrary math using python
" -------------------------------

" solves the given mathemical expression and returns the result
function! EvalMathExpression(exp) 
    execute "python sys.argv = [\"" . a:exp . "\"]"
    python sys.argv[0] = eval(sys.argv[0])
    python vim.command("let out = \"" + str(sys.argv[0]) + "\"")
    return out
endfunction

" -------------------------------
" grep functions
" -------------------------------

" greps recursively from the current working directory
function! GrepRecurse(arg)
    silent! execute "silent! grep! -r """ . shellescape(getreg(a:arg)) . """"
    cw
    redraw!
endfunction

" greps recursively from the current working directory
function! GrepRecurseRegister()
    silent! execute "silent! grep! -r """ . shellescape(getreg(v:register)) . """"
    cw
    redraw!
endfunction

" greps in the current window
function! GrepCurrentRegister()
    silent! execute "silent! grep! """ . shellescape(getreg(v:register)) . """ % "
    cw
    redraw!
endfunction

" greps in all windows
function! GrepWindowRegister() 
    call setqflist([]) 
    cclose
    windo silent! execute "silent! grepadd! """ . shellescape(getreg(v:register)) . """ %"
    cw
    redraw!
endfunction

" greps recursively for all directories in the path
function! GrepPathRegister()
    let plist = GetPathString()
    silent! execute "silent! grep! -r """ . shellescape(getreg(v:register)) . """ " . plist
    cw
    redraw!
endfunction

" -------------------------------
" window functions
" -------------------------------

" returns the list of buffers in string format
function! GetBufferList()
    redir =>buflist
    silent! ls
    redir END
    return buflist
endfunction

" toggles the specified window
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

" toggles diff on the current window
function! ToggleDiff()
    if &diff
        diffoff
    else
        diffthis
    endif
endfunction

" -------------------------------
" operator wrapping functions
" -------------------------------

" used as an operator function with a callback. passes arguments via the current register.
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

" wraps operator functions that rely on simple input text
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
" url encoding functions
" -------------------------------

let g:urlRanges = [[0, 32], [34, 38], [43, 44], [47, 47], [58, 64], [91, 94], [96, 96], [123, 127], [128, 255]]
let g:urlRangeCount = len(urlRanges)

" does a binary search for whether or not the current character is in the url encoding range
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

" returns whether or not a character needs to be url encoded
function! UrlEncodeChar(charByte)
    return UrlEncodeCharInternal(a:charByte, 0, g:urlRangeCount - 1)
endfunction

" url encodes the current register
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

" url decodes the current register
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
" operator functions
" -------------------------------

function! HelpOperator(type)
    call OperatorWrapper(a:type, "call ViewDoc('doc', getreg(v:register))")
endfunction

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
" set function mappings
" -------------------------------

" performs a topological sort
function! TopologicalSortRegister()
    call setreg(v:register, system("tsort", getreg(v:register)))
endfunction

" gets the compliment of two sets
function! ComplimentRegister()
    let A = uniq(sort(split(getreg(v:register), "\n")))
    let B = uniq(sort(split(getreg(input("Enter register: ")), "\n")))
    call filter(A, 'index(B, v:val) < 0')
    call setreg(v:register, join(A, "\n"))
endfunction

" gets the symmetric difference of two sets
function! SymmetricDifferenceRegister()
    call setreg(v:register, join(uniq(sort(split(getreg(v:register), "\n")), "DuplicateBlockFunction"), "\n"))
endfunction

" used for sorting based on string length
function! LengthFunction(arg1, arg2)
    return strlen(a:arg1) - strlen(a:arg2)
endfunction

" sorts strings based on their length
function! SortStringLengthRegister()
    call setreg(v:register, join(sort(split(getreg(v:register), "\n"), "LengthFunction"), "\n"))
endfunction

" Reverse sorts strings based on their length
function! ReverseSortStringLengthRegister()
    call setreg(v:register, join(reverse(sort(split(getreg(v:register), "\n"), "LengthFunction")), "\n"))
endfunction

" shuffle the input lines
function! ShuffleRegister()
    call setreg(v:register, system("shuf", getreg(v:register)))
endfunction

" replace input lines with a sequence of numbers
function! SequenceRegister()
    let linecount=len(split(getreg(v:register), "\n"))
    call setreg(v:register, system('seq ' . linecount, getreg(v:register)))
endfunction

" joins newline separated values with spaces
function! JoinRegister()
    call setreg(v:register, join(split(getreg(v:register), "\n"), " "))
endfunction

" joins newline separated values with user specified delimiter
function! JoinSeparatorRegister()
    let delimiter = input("Enter delimiter: ")
    call setreg(v:register, join(split(getreg(v:register), "\n"), delimiter))
endfunction

" removes duplicates
function! UniqueRegister()
    call setreg(v:register, join(uniq(sort(split(getreg(v:register), "\n"))), "\n"))
endfunction

" checks if adjacent values are the same
function! DuplicateFunction(arg1, arg2) 
    return a:arg1 ==# a:arg2 
endfunction

" finds blocks of adjacent values that are the same
function! DuplicateBlockFunction(arg1, arg2)
    if a:arg1 ==# a:arg2 || a:arg1 ==# g:DuplicateValue 
        let g:DuplicateValue = a:arg1
        return 0 
    endif
    return 1
endfunction

" removes unique values (set intersection) 
" also: 
" join <(sort -n A) <(sort -n B)
" sort -n A B | uniq -d
" grep -xF -f A B
" comm -12 <(sort -n A) <(sort -n B)
function! DuplicateRegister()
    let g:DuplicateValue = ""
    call setreg(v:register, join(uniq(uniq(sort(add(split(getreg(v:register), "\n"), "")), "DuplicateFunction")), "\n"))
endfunction

" sorts the given text
function! SortRegister()
    call setreg(v:register, join(sort(split(getreg(v:register), "\n")), "\n"))
endfunction

" reverse sorts the given text
function! SortReverseRegister()
    call setreg(v:register, join(reverse(sort(split(getreg(v:register), "\n"))), "\n"))
endfunction

" -------------------------------
" text function mappings
" -------------------------------

" creates sha256 hash
function! Sha256Register()
    call setreg(v:register, sha256(getreg(v:register)))
endfunction

" splits up values
function! SplitRegister()
    let delimiter = input("Enter delimiter: ")
    call setreg(v:register, join(split(getreg(v:register), delimiter), "\n"))
endfunction

" executes and replaces given commands
function! ExternalRegister()
    call setreg(v:register, system(&shell, getreg(v:register)))
    call setreg(v:register, substitute(getreg(v:register), "^\n", "", "") )
    call setreg(v:register, substitute(getreg(v:register), "\n$", "", "") )
endfunction

" performs a regex substitution on the given text
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

" performs a regex substitution on the given text
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

" evaluates mathematical expressions
function! MathExpressionRegister() 
    call setreg(v:register, EvalMathExpression(getreg(v:register)))
endfunction

" makes text title case
function! TitleCaseRegister()
    call setreg(v:register, substitute(getreg(v:register), "\\v<(.)(\\w*)>", "\\u\\1\\L\\2", "g") )
endfunction

" creates a table from space separated arguments
function! TableRegister()
    call setreg(v:register, system("column -t", getreg(v:register)))
endfunction

" creates a table from comma separated arguments
function! TableSeparatorRegister()
    let delimiter = input("Enter delimiter: ")
    call setreg(v:register, system("column -s" . shellescape(delimiter) ." -t", getreg(v:register)))
endfunction

" converts unix text to mac
function! UnixToMacRegister()
    call setreg(v:register, system("unix2mac -f", getreg(v:register)))
endfunction

" converts mac text to unix
function! MacToUnixRegister()
    call setreg(v:register, system("mac2unix -f", getreg(v:register)))
endfunction

" converts dos text to unix
function! DosToUnixRegister()
    call setreg(v:register, system("dos2unix -f", getreg(v:register)))
endfunction

" converts unix text to dos
function! UnixToDosRegister()
    call setreg(v:register, system("unix2dos -f", getreg(v:register)))
endfunction

" converts cpp name mangled strings to their pretty counterparts
function! CppFilterRegister()
    call setreg(v:register, system("c++filt", getreg(v:register)))
endfunction

" performs crc32 on selected text
function! CrcRegister() 
    call setreg(v:register, system("cksum", getreg(v:register)))
    call setreg(v:register, substitute(getreg(v:register), "\\n", "", "g"))
    call setreg(v:register, substitute(getreg(v:register), " .*", "", "g"))
endfunction

" performs md5 on selected text
function! Md5Register() 
    call setreg(v:register, system("md5sum", getreg(v:register)))
    call setreg(v:register, substitute(getreg(v:register), "\\n", "", "g"))
    call setreg(v:register, substitute(getreg(v:register), " .*", "", "g"))
endfunction

" base64 encodes text
function! Base64Register() 
    call setreg(v:register, system("base64", getreg(v:register)))
    call setreg(v:register, substitute(getreg(v:register), "\\n", "", "g"))
endfunction

" base64 decodes text
function! Base64DecodeRegister() 
    call setreg(v:register, system("base64 -d", getreg(v:register)))
    call setreg(v:register, substitute(getreg(v:register), "\\n", "", "g"))
endfunction

" -------------------------------
" miscellaneous mappings
" -------------------------------

" leader
let mapleader="\\"

" escape
inoremap jk <Esc>

" reload .vimrc
nnoremap <leader>lg :source ~/.vimrc<CR>
nnoremap <leader>ll :source ./.vimrc<CR>

" build
nnoremap <leader>k :make<CR>

" make y behave like other capitals
nnoremap Y y$

" make command mode work like readline
cnoremap <C-a> <Home>

" create visual mode mapping
vmap K <Plug>(operator-help)
call operator#user#define('help', 'HelpOperator')

" -------------------------------
" window navigation mappings
" -------------------------------

" quick window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" -------------------------------
" cscope mappings
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
" window mappings
" -------------------------------

nnoremap <leader>wn :NERDTreeToggle<CR>
nnoremap <leader>wt :TagbarToggle<CR>
nnoremap <leader>wg :GundoToggle<CR>
nnoremap <leader>we :CCTreeWindowToggle<CR>
nnoremap <leader>wx :call ToggleHex()<CR>
nnoremap <leader>wd :call ToggleDiff()<CR>
nnoremap <leader>wc :call ToggleList("Quickfix List", 'c')<CR>
nnoremap <leader>wo :call GrepRecurse("TODO")<CR>
nnoremap <leader>wa :AS<CR>
nnoremap <leader>wl :set number!<CR>
nnoremap <leader>ww :set wrap!<CR>
nnoremap <leader>wr :redraw!<CR>
nnoremap <leader>wz :set spell!<CR> 
set pastetoggle=<leader>wp

" -------------------------------
" quickfix mappings
" -------------------------------

augroup quickfix_mappings
    autocmd!
    autocmd BufReadPost quickfix nnoremap <buffer> u :colder<CR>
    autocmd BufReadPost quickfix nnoremap <buffer> <c-r> :cnewer<CR>
augroup END

" -------------------------------
" grep operator mappings
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
" text transformation mappings
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
" set operation mappings
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
" .vimrc reload mappings
" -------------------------------

nnoremap <leader>lg :source ~/.vimrc<CR>
nnoremap <leader>ll :source ./.vimrc<CR>

" -------------------------------
" local .vimrc settings
" -------------------------------

if filereadable(glob("~/.vimrc_local"))
    source ~/.vimrc_local
endif

