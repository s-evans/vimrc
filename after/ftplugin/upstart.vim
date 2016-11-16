" define a custom help handler for upstart files
" TODO: add DEFAULT help handler for commands invoked by upstart scripts?
function! s:ViewDoc_upstart(topic, filetype, synid, ctx)
    return {
                \'cmd':    'man -s 5 init',
                \'ft':     'man',
                \'search': '^[ ]\+' . a:topic . '\>',
                \}
endfunction
let g:ViewDoc_upstart=[ function('s:ViewDoc_upstart') ]
