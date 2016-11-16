" js-beautify support
if executable("js-beautify")
    let g:format_prg['json'] = 'js-beautify -'
endif
