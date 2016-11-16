" define a custom help handler for apt.conf files
function! s:ViewDoc_aptconf(topic, filetype, synid, ctx)
    return {
                \'cmd':    'man apt.conf',
                \'ft':     'man',
                \'search': '^[ ]\+' . a:topic . '\>',
                \}
endfunction
let g:ViewDoc_aptconf=[ function('s:ViewDoc_aptconf') ]
