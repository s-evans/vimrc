if !has_key(g:format_prg, 'html')
    " html-beautify support
    if executable('html-beautify')
        let g:format_prg['html'] = 'html-beautify -f -'
    endif

    " xmlstarlet support
    if executable('xmlstarlet')
        let g:format_prg['html'] = 'xmlstarlet -q fo --html -'
    endif

    " tidy support
    if executable('tidy')
        let g:format_prg['html'] = 'tidy -q --show-errors 0 --show-warnings 0 --force-output --indent auto --vertical-space yes --tidy-mark no'
    endif
endif
