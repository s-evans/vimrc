if executable('ktlint')
    let b:format_prg = 'ktlint -F --stdin . 2> /dev/null'
endif

setlocal commentstring=//\ %s
