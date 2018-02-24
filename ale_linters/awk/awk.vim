function! ale_linters#awk#awk#HandleFormat(buffer, lines) abort
    " Look for lines like the following.
    " gawk: test.cpp:5:  Estra space after ( in function call [whitespace/parents] [4]
    let l:pattern = '^[g]\?awk: .\{-}:\(\d\+\): *\(.\+\)'
    let l:output = []

    for l:match in ale#util#GetMatches(a:lines, l:pattern)
        call add(l:output, {
        \   'lnum': l:match[1] + 0,
        \   'col': 0,
        \   'text': join(split(l:match[2])),
        \   'code': l:match[3],
        \   'type': 'W',
        \})
    endfor

    return l:output
endfunction

call ale#linter#Define('awk', {
\   'name': 'awk',
\   'executable_callback': 'ale_linters#awk#gawk#GetExecutable',
\   'command_callback': 'ale_linters#awk#gawk#GetCommand',
\   'callback': 'ale_linters#awk#awk#HandleFormat',
\   'output_stream': 'both'
\})
