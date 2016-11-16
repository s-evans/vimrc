" xmlstarlet support
if executable("xmlstarlet")
    let g:format_prg['xhtml'] = 'xmlstarlet -q fo -'
endif

" tidy support
if executable("tidy")
    let g:format_prg['xhtml'] = 'tidy -q --show-errors 0 --show-warnings 0 --force-output --indent auto --vertical-space yes --tidy-mark no'
endif

