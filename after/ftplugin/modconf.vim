" define a custom help handler for modules files
function! s:ViewDoc_modconf(topic, filetype, synid, ctx)
    return {
                \'cmd':    'man modules',
                \'ft':     'man',
                \'search': '^[ ]\+' . a:topic . '\>',
                \}
endfunction
let g:ViewDoc_modconf=[ function('s:ViewDoc_modconf') ]
