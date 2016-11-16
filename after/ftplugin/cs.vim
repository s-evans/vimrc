let g:ViewDoc_cs=[ 'ViewDoc_DEFAULT', 'ViewDoc_help_custom', function('ViewDoc_hlpviewer') ]
if !has_key(g:format_prg, 'cs')
    " astyle support
    if executable("astyle")
        let g:format_prg['cs'] = 'astyle --mode=cs'
    endif
endif
