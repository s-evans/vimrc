" xmllint support
if executable('xmllint')
    let b:format_prg = 'xmllint --format -'
endif
