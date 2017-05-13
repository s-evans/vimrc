" xmllint support
if executable('xmllint')
    let b:format_prg = 'xmllint --format -'
endif

" xmlstarlet support
if executable('xmlstarlet')
    let b:format_prg = 'xmlstarlet -q fo -'
endif

" tidy support
if executable('tidy')
    let b:format_prg = 'tidy -q -xml --show-errors 0 --show-warnings 0 --force-output --indent auto --vertical-space yes --tidy-mark no'
endif
