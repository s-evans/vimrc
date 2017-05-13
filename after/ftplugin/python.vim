" yapf support
if executable('yapf')
    let b:format_prg = 'yapf'
endif

" autopep8 support
if executable('autopep8')
    let b:format_prg = 'autopep8 -'
endif
