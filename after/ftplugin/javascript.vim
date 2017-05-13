" js-beautify support
if executable('js-beautify')
    let b:format_prg = 'js-beautify -'
endif

" jscs support
if executable('jscs')
    let b:format_prg = 'jscs -x'
endif

" clang-format support
if executable('clang-format')
    let b:format_prg = 'clang-format -style=file'
endif
