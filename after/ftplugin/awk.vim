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

" configure viewdoc
let g:ViewDocInfoIndex_awk = [ '(gawk)Index' ]
let g:ViewDoc_awk=[ 'ViewDoc_search', function('s:ViewDoc_awk') ]

" parse awk lint output
function! SyntaxCheckers_awk_awk_GetLocList() dict
    let makeprg = self.makeprgBuild({
                \ 'exe' : 'awk',
                \ 'args' : '--lint -f'
                \})

    let errorformat = 'awk: %f:%l: %m'

    return SyntasticMake({
        \ 'makeprg': makeprg,
        \ 'errorformat': errorformat,
        \ 'returns': [0, 1] })
endfunction

" register awk syntax checker
if !exists('g:loaded_syntastic_awk_checker') && exists('g:SyntasticRegistry')
    call g:SyntasticRegistry.CreateAndRegisterChecker({
                \ 'filetype': 'awk',
                \ 'name': 'awk'
                \})
    let g:loaded_syntastic_awk_checker = 1
endif
