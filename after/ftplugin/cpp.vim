let g:ViewDoc_cpp=[ 'ViewDoc_DEFAULT', 'ViewDoc_help_custom', function('ViewDoc_hlpviewer') ]

if !has_key(g:format_prg, 'cpp')
    " clang-format support
    if executable('clang-format')
        let g:format_prg['cpp'] = 'clang-format -style=file'
    endif

    " astyle support
    if executable('astyle')
        let g:format_prg['cpp'] = 'astyle'
    endif
endif