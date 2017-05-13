function! s:ViewDoc_spec(topic, filetype, synid, ctx)
    return {
                \'cmd':    'man rpmbuild',
                \'ft':     'man',
                \'search': '^[ ]\+' . a:topic . '\>',
                \}
endfunction
let g:ViewDoc_spec=[ function('s:ViewDoc_spec'), 'ViewDoc_DEFAULT' ]

setlocal commentstring=#\ %s
setlocal comments=b:#
