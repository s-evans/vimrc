" astyle support
if executable('astyle')
    let b:format_prg = 'astyle --mode=java'
endif
