" xmlstarlet support
if executable('xmlstarlet')
    let b:format_prg = 'xmlstarlet -q fo -'
endif

" tidy support
if executable('tidy')
    let b:format_prg = 'tidy -config ~/.htmltidyrc'
endif
