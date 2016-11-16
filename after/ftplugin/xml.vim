" xmllint support
if executable("xmllint")
    let g:format_prg['xml'] = 'xmllint --format -'
endif

" xmlstarlet support
if executable("xmlstarlet")
    let g:format_prg['xml'] = 'xmlstarlet -q fo -'
endif

" tidy support
if executable("tidy")
    let g:format_prg['xml'] = 'tidy -q -xml --show-errors 0 --show-warnings 0 --force-output --indent auto --vertical-space yes --tidy-mark no'
endif

