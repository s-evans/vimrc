let g:ViewDoc_css=[ 'ViewDoc_help_custom' ]

" css-beautify support
if executable('css-beautify')
    let b:format_prg = 'css-beautify -f -'
endif
