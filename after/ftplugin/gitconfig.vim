" define a custom help handler for gitconfig files
function! s:ViewDoc_gitconfig(topic, filetype, synid, ctx)
    return {
                \'cmd':    'man git-config',
                \'ft':     'man',
                \'search': '^[ ]\+' . a:topic . '\>',
                \}
endfunction
let g:ViewDoc_gitconfig=[ function('s:ViewDoc_gitconfig') ]
