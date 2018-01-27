" define a custom help handler for samba files
function! s:ViewDoc_samba(topic, filetype, synid, ctx)
    return {
                \'cmd':    'man smb.conf',
                \'ft':     'man',
                \'search': '^[ ]\+' . a:topic . '\>',
                \}
endfunction
let g:ViewDoc_samba=[ function('s:ViewDoc_samba') ]

" comment string settings
let b:commentary_format='// %s'
