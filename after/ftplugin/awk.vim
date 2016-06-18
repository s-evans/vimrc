" comment settings
setlocal commentstring=#\ %s
setlocal comments=b:#

" define a custom help handler for awk files
function! s:ViewDoc_awk(topic, filetype, synid, ctx)
    return {
                \'cmd':    'man gawk',
                \'ft':     'man',
                \'search': '^[ ]\+' . a:topic,
                \}
endfunction
let g:ViewDocInfoIndex_awk = [ '(gawk)Index' ]
let g:ViewDoc_readline=[ 'ViewDoc_search' ]
let g:ViewDoc_awk=[ 'ViewDoc_search', function('s:ViewDoc_awk') ]
