" indent settings

let s:begin_context=[ '^application$', '^call-manager-fallback$', '^class-map ',
            \'^control-plane$', '^ip access-list', '^ipv6 access-list',
            \'^controller ', '^crypto ', '^dial-peer ', '^dspfarm ', '^flow ',
            \'^gatekeeper$', '^interface ', '^ip dhcp ', '^line ',
            \'^policy-map ', '^redundancy$', '^router ', '^vlan ',
            \'^voice service ', '^voice-card ', '^vrf definition ',
            \'^aaa group ', '^key chain ' ]

function! GetCiscoIndent()
  let prev_lnum = v:lnum - 1

  if prev_lnum == 0
    return 0
  endif

  if getline(v:lnum) =~# '^[ ]*!'
      return 0
  endif

  let prev_line = getline(prev_lnum)

  if prev_line =~# '^[ ]*!'
      return 0
  endif

  if prev_line =~# '^ '
      return indent(prev_lnum)
  endif

  for pattern in s:begin_context
      if prev_line =~# pattern
          return &sw
      endif
  endfor

  return 0
endfunction

setlocal indentexpr=GetCiscoIndent()
setlocal indentkeys=!^F,o,O,=!

" tab settings

setlocal softtabstop=1
setlocal shiftwidth=1
setlocal tabstop=1

" comment settings

setlocal commentstring=!\ %s
setlocal comments=b:!

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

