" define a custom help handler for netrc files
function! s:ViewDoc_netrc(topic, filetype, synid, ctx)
    return {
                \'cmd':    'man netrc',
                \'ft':     'man',
                \'search': '^[ ]\+' . a:topic . '\>',
                \}
endfunction
let g:ViewDoc_netrc=[ function('s:ViewDoc_netrc') ]
