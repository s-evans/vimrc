" xmllint support
if executable("xmllint")
    let g:format_prg['xslt'] = 'xmllint --format -'
endif
