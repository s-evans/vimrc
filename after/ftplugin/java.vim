" astyle support
if executable("astyle")
    let g:format_prg['java'] = 'astyle --mode=java'
endif
