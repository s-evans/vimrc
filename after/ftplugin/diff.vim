
" Next change
nmap <buffer> ]c :echo search("^diff")<CR>
nmap <buffer> [c :echo search("^diff", "b")<CR>

" Next section
nmap <buffer> ]] :echo search("^diff")<CR>
nmap <buffer> [[ :echo search("^diff", "b")<CR>

" Next paragraph
nmap <buffer> } :echo search('\v^diff\|^[@0-9]')<CR>
nmap <buffer> { :echo search('\v^diff\|^[@0-9]', "b")<CR>

