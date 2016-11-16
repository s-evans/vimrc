" yapf support
if executable("yapf")
    let g:format_prg['python'] = 'yapf'
endif

" autopep8 support
if executable("autopep8")
    let g:format_prg['python'] = 'autopep8 -'
endif
