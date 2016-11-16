" define a custom help handler for screenrc files
function! s:ViewDoc_screen(topic, filetype, synid, ctx)
    return {
                \'cmd':    'man screen',
                \'ft':     'man',
                \'search': '^[ ]\+' . a:topic . '\>',
                \}
endfunction
let g:ViewDoc_screen=[ function('s:ViewDoc_screen') ]
