let g:ViewDoc_cpp=[ 'ViewDoc_DEFAULT', 'ViewDoc_help_custom', function('ViewDoc_hlpviewer') ]

" clang-format support
if executable('clang-format')
    let b:format_prg = 'clang-format -style=file'
endif

" astyle support
if executable('astyle')
    let b:format_prg = 'astyle'
endif
