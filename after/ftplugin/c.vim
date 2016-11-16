let g:ViewDoc_c=[ 'ViewDoc_DEFAULT', 'ViewDoc_help_custom' ]

" clang-format support
if executable("clang-format")
    let g:format_prg['c'] = 'clang-format -style=file'
endif

" astyle support
if executable("astyle")
    let g:format_prg['c'] = 'astyle'
endif
