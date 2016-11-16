" define a custom help handler for sysctl files
function! s:ViewDoc_sysctl(topic, filetype, synid, ctx)
    return {
                \'cmd':    'sysctl --all',
                \'ft':     'sysctl',
                \'search': a:topic,
                \}
endfunction
let g:ViewDoc_sysctl=[ function('s:ViewDoc_sysctl') ]
