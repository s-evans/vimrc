" define a custom help handler for xf86conf files
function! s:ViewDoc_xf86conf(topic, filetype, synid, ctx)
    return {
                \'cmd':    'man xorg.conf',
                \'ft':     'man',
                \'search': '^[ ]\+' . a:topic . '\>',
                \}
endfunction
let g:ViewDoc_xf86conf=[ function('s:ViewDoc_xf86conf') ]
