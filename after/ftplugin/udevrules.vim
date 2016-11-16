" define a custom help handler for udev files
function! s:ViewDoc_udev(topic, filetype, synid, ctx)
    return {
                \'cmd':    'man udev',
                \'ft':     'man',
                \'search': '^[ ]\+' . a:topic . '\>',
                \}
endfunction
let g:ViewDoc_udevrules=[ function('s:ViewDoc_udev') ]
