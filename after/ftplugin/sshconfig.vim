" define a custom help handler for sshconfig files
function! s:ViewDoc_sshconfig(topic, filetype, synid, ctx)
    return {
                \'cmd':    'man ssh_config',
                \'ft':     'man',
                \'search': '^[ ]\+' . a:topic . '\>',
                \}
endfunction
let g:ViewDoc_sshconfig=[ function('s:ViewDoc_sshconfig') ]
