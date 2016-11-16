if !has_key(g:format_prg, 'java')
    " astyle support
    if executable("astyle")
        let g:format_prg['java'] = 'astyle --mode=java'
    endif
endif
