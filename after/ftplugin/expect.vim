" define a custom help handler for expect files
function! s:ViewDoc_expect(topic, filetype, synid, ctx)
    return {
                \'cmd':    'man expect',
                \'ft':     'man',
                \'search': '^[ ]\+' . a:topic . '\>',
                \}
endfunction
let g:ViewDoc_expect=[ function('s:ViewDoc_expect') ]
