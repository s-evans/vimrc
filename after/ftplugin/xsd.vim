if !has_key(g:format_prg, 'xsd')
    " xmllint support
    if executable("xmllint")
        let g:format_prg['xsd'] = 'xmllint --format -'
    endif
endif
