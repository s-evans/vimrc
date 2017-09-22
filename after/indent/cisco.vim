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
    let prev_lnum = v:lnum - 1

    if prev_lnum == 0
        return 0
    endif

    if getline(v:lnum) =~# '^[ ]*!'
        return 0
    endif

    let prev_line = getline(prev_lnum)
    let prev_idt = indent(prev_lnum)

    if prev_line =~# '^[ ]*!'
        return 0
    endif

    if prev_line =~# '^ '
        return prev_idt
    endif

    for pattern in s:begin_context
        if prev_line =~# pattern
            return prev_idt + &sw
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
