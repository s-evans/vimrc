" define a custom help handler for terminfo files
function! s:ViewDoc_terminfo(topic, filetype, synid, ctx)
    return {
                \'cmd':    'man terminfo',
                \'ft':     'man',
                \'search': '^[ ]\+' . a:topic . '\>',
                \}
endfunction
let g:ViewDoc_terminfo=[ function('s:ViewDoc_terminfo') ]
