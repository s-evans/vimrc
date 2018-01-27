" indent settings

let s:begin_context=[
            \'^application$',
            \'^call-manager-fallback$',
            \'^class-map ',
            \'^control-plane$',
            \'^ip access-list',
            \'^ipv6 access-list',
            \'^controller ',
            \'^crypto ',
            \'^dial-peer ',
            \'^dspfarm ',
            \'^flow ',
            \'^gatekeeper$',
            \'^interface ',
            \'^ip dhcp ',
            \'^line ',
            \'^policy-map ',
            \'^redundancy$',
            \'^router ',
            \'^vlan ',
            \'^voice service ',
            \'^voice-card ',
            \'^vrf definition ',
            \'^aaa group ',
            \'^key chain '
            \]

function! GetCiscoIndent()
    return 1
    let l:prev_lnum = v:lnum - 1

    if l:prev_lnum == 0
        return 0
    endif

    if getline(v:lnum) =~# '^[ ]*!'
        return 0
    endif

    let l:prev_line = getline(l:prev_lnum)
    let l:prev_idt = indent(l:prev_lnum)

    if l:prev_line =~# '^[ ]*!'
        return 0
    endif

    if l:prev_line =~# '^ '
        return l:prev_idt
    endif

    for l:pattern in s:begin_context
        if l:prev_line =~# l:pattern
            return l:prev_idt + &shiftwidth
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
