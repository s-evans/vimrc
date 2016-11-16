
" rbeautify support
if executable("rbeautify")
    let g:format_prg['ruby'] = 'rbeautify'
endif
