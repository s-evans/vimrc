let g:ViewDoc_c=[ 'ViewDoc_DEFAULT', 'ViewDoc_help_custom', function('ViewDoc_hlpviewer') ]

if !has_key(g:format_prg, 'c')
    " clang-format support
    if executable('clang-format')
        let g:format_prg['c'] = 'clang-format -style=file'
    endif

    " astyle support
    if executable('astyle')
        let g:format_prg['c'] = 'astyle'
    endif
endif
