" define a custom help handler for sshdconfig files
function! s:ViewDoc_sshdconfig(topic, filetype, synid, ctx)
    return {
                \'cmd':    'man sshd_config',
                \'ft':     'man',
                \'search': '^[ ]\+' . a:topic . '\>',
                \}
endfunction
let g:ViewDoc_sshdconfig=[ function('s:ViewDoc_sshdconfig') ]
setlocal commentstring=#\ %s
setlocal comments=b:#
