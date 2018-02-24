let g:ale_sed_sed_executable =
\   get(g:, 'ale_sed_sed_executable', 'sed')

let g:ale_sed_sed_options =
\   get(g:, 'ale_sed_sed_options', '')

function! ale_linters#sed#sed#HandleFormat(buffer, lines) abort
    let l:pattern = '^sed: file .\{-} line \(\d\+\): *\(.\+\)'
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

function! ale_linters#sed#sed#GetExecutable(buffer) abort
    return ale#Var(a:buffer, 'sed_sed_executable')
endfunction

function! ale_linters#sed#sed#GetCommand(buffer) abort
    return ale_linters#sed#sed#GetExecutable(a:buffer)
    \   . ' ' . ale#Var(a:buffer, 'sed_sed_options')
    \   . ' ' . '-f %t /dev/null'
endfunction

call ale#linter#Define('sed', {
\   'name': 'sed',
\   'executable_callback': 'ale_linters#sed#sed#GetExecutable',
\   'command_callback': 'ale_linters#sed#sed#GetCommand',
\   'callback': 'ale_linters#sed#sed#HandleFormat',
\   'output_stream': 'both'
\})
