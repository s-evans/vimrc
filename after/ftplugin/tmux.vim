" define a custom help handler for tmux files
function! s:ViewDoc_tmux(topic, filetype, synid, ctx)
    return {
                \'cmd':    'man tmux',
                \'ft':     'man',
                \'search': '^[ ]\+' . a:topic . '\>',
                \}
endfunction
let g:ViewDoc_tmux=[ function('s:ViewDoc_tmux') ]
