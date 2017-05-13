" clang-format support
if executable('clang-format')
    let b:format_prg = 'clang-format -style=file'
endif
