" define a custom help handler for wget files
function! s:ViewDoc_wget(topic, filetype, synid, ctx)
    return {
                \'cmd':    'man wget',
                \'ft':     'man',
                \'search': '^[ ]\+' . a:topic . '\>',
                \}
endfunction
let g:ViewDoc_wget=[ function('s:ViewDoc_wget') ]
