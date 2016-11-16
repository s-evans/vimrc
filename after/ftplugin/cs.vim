" astyle support
if executable("astyle")
    let g:format_prg['cs'] = 'astyle --mode=cs'
endif

