if !has_key(g:format_prg, 'javascript')
    " js-beautify support
    if executable('js-beautify')
        let g:format_prg['javascript'] = 'js-beautify -'
    endif

    " jscs support
    if executable('jscs')
        let g:format_prg['javascript'] = 'jscs -x'
    endif

    " clang-format support
    if executable('clang-format')
        let g:format_prg['javascript'] = 'clang-format -style=file'
    endif
endif
