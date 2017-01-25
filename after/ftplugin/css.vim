let g:ViewDoc_css=[ 'ViewDoc_help_custom' ]

if !has_key(g:format_prg, 'css')
    " css-beautify support
    if executable('css-beautify')
        let g:format_prg['css'] = 'css-beautify -f -'
    endif
endif
