" define a custom help handler for resolv.conf files
function! s:ViewDoc_resolv(topic, filetype, synid, ctx)
    return {
                \'cmd':    'man resolv.conf',
                \'ft':     'man',
                \'search': '^[ ]\+' . a:topic . '\>',
                \}
endfunction
let g:ViewDoc_resolv=[ function('s:ViewDoc_resolv') ]
