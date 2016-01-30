
" section functions

function! s:cisco_fwd_top_section()
    call search('^!\n[^!]', 'W')
endfunction

function! s:cisco_fwd_top_section_visual()
    normal! gvj
    call s:cisco_fwd_top_section()
endfunction

function! s:cisco_fwd_bot_section()
    let lineno=search('[^!].*\n^!$', 'We')
endfunction

function! s:cisco_fwd_bot_section_visual()
    normal! gvj
    call s:cisco_fwd_bot_section()
endfunction

function! s:cisco_rev_top_section()
    call search('^!\n[^!]', 'bW')
endfunction

function! s:cisco_rev_top_section_visual()
    normal! gvk
    call s:cisco_rev_top_section()
endfunction

function! s:cisco_rev_bot_section()
    call s:cisco_rev_top_section()
    call s:cisco_rev_top_section()
    call s:cisco_fwd_bot_section()
endfunction

function! s:cisco_rev_bot_section_visual()
    normal! gvk
    call s:cisco_rev_bot_section()
endfunction

" section mappings

noremap <buffer> <silent> ]] :call <SID>cisco_fwd_top_section()<CR>
vnoremap <buffer> <silent> ]] :<c-u>call <SID>cisco_fwd_top_section_visual()<CR>

noremap <buffer> <silent> ][ :call <SID>cisco_fwd_bot_section()<CR>
vnoremap <buffer> <silent> ][ :<c-u>call <SID>cisco_fwd_bot_section_visual()<CR>

noremap <buffer> <silent> [[ :call <SID>cisco_rev_top_section()<CR>
vnoremap <buffer> <silent> [[ :<c-u>call <SID>cisco_rev_top_section_visual()<CR>

noremap <buffer> <silent> [] :call <SID>cisco_rev_bot_section()<CR>
vnoremap <buffer> <silent> [] :<c-u>call <SID>cisco_rev_bot_section_visual()<CR>
