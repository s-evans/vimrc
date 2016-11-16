" xmllint support
if executable("xmllint")
    let g:format_prg['xsd'] = 'xmllint --format -'
endif
