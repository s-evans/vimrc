" comment settings
setlocal commentstring=#\ %s
setlocal comments=b:#

" define a custom help handler for fstab files
function! s:ViewDoc_fstab(topic, filetype, synid, ctx)
    return {
                \'cmd':    'man fstab',
                \'ft':     'man',
                \}
endfunction
let g:ViewDoc_fstab=[ function('s:ViewDoc_fstab') ]
