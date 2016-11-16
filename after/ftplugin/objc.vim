if !has_key(g:format_prg, 'objc')
    " clang-format support
    if executable("clang-format")
        let g:format_prg['objc'] = 'clang-format -style=file'
    endif
endif
