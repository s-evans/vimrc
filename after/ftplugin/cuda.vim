" make more like cpp
runtime! ftplugin/cpp.vim ftplugin/cpp_*.vim ftplugin/cpp/*.vim

" import c and cpp snippets from snipmate
let g:snipMate.scope_aliases['cuda'] = 'cpp'

" custom help handler for cuda
let g:ViewDoc_cuda=[ 'ViewDoc_DEFAULT', 'ViewDoc_help_custom' ]

if !has_key(g:format_prg, 'cuda')
    " clang-format support
    if executable('clang-format')
        let g:format_prg['cuda'] = 'clang-format -style=file'
    endif

    " astyle support
    if executable('astyle')
        let g:format_prg['cuda'] = 'astyle'
    endif
endif

" -------------------------------
" a-vim settings
" -------------------------------

let g:alternateExtensions_cu = 'h,hpp'
let g:alternateExtensions_CU = 'H,HPP'
