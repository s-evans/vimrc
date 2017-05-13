" html-beautify support
if executable('html-beautify')
    let b:format_prg = 'html-beautify -f -'
endif

" xmlstarlet support
if executable('xmlstarlet')
    let b:format_prg = 'xmlstarlet -q fo --html -'
endif

" tidy support
if executable('tidy')
    let b:format_prg = 'tidy -q --show-errors 0 --show-warnings 0 --force-output --indent auto --vertical-space yes --tidy-mark no'
endif
