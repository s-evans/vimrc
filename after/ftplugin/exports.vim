function! s:ViewDoc_exports(topic, filetype, synid, ctx)
    return {
                \'cmd':    'man exports',
                \'ft':     'man',
                \'search': '^[ ]\+' . a:topic . '\>',
                \}
endfunction
let g:ViewDoc_exports=[ function('s:ViewDoc_exports') ]

setlocal commentstring=#\ %s
setlocal comments=b:#
