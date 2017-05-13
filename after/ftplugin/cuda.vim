" make more like cpp
runtime! ftplugin/cpp.vim ftplugin/cpp_*.vim ftplugin/cpp/*.vim

" import c and cpp snippets from snipmate
let g:snipMate.scope_aliases['cuda'] = 'cpp'

" custom help handler for cuda
let g:ViewDoc_cuda=[ 'ViewDoc_DEFAULT', 'ViewDoc_help_custom' ]

" clang-format support
if executable('clang-format')
    let b:format_prg = 'clang-format -style=file'
endif

" astyle support
if executable('astyle')
    let b:format_prg = 'astyle'
endif

" -------------------------------
" a-vim settings
" -------------------------------

let g:alternateExtensions_cu = 'h,hpp'
let g:alternateExtensions_CU = 'H,HPP'
