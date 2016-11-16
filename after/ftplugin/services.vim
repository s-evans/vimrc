" define a custom help handler for services files
function! s:ViewDoc_services(topic, filetype, synid, ctx)
    return {
                \'cmd':    'man services',
                \'ft':     'man',
                \'search': '^[ ]\+' . a:topic . '\>',
                \}
endfunction
let g:ViewDoc_services=[ function('s:ViewDoc_services') ]
