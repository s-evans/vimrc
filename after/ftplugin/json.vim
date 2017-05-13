" js-beautify support
if executable('js-beautify')
    let b:format_prg = 'js-beautify -'
endif
