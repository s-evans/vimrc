" define a custom help handler for host.conf files
function! s:ViewDoc_hostconf(topic, filetype, synid, ctx)
    return {
                \'cmd':    'man host.conf',
                \'ft':     'man',
                \'search': '^[ ]\+' . a:topic . '\>',
                \}
endfunction
let g:ViewDoc_hostconf=[ function('s:ViewDoc_hostconf') ]
