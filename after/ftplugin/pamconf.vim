" define a custom help handler for pamconf files
function! s:ViewDoc_pamconf(topic, filetype, synid, ctx)
    return {
                \'cmd':    'man pam.conf',
                \'ft':     'man',
                \'search': '^[ ]\+' . a:topic . '\>',
                \}
endfunction
let g:ViewDoc_pamconf=[ function('s:ViewDoc_pamconf') ]
