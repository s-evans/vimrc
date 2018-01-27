setlocal commentstring=#\ %s
setlocal comments=b:#

" define a custom help handler for sed files
let g:ViewDocInfoIndex_sed = [ '(sed)Command and Option Index' ]
let g:ViewDoc_sed=[ 'ViewDoc_search' ]

" parse sed lint output
function! SyntaxCheckers_sed_sed_GetLocList() dict
    let l:makeprg = l:self.makeprgBuild({
                \ 'exe' : 'sed',
                \ 'args' : '-f'
                \})

    let l:errorformat = 'sed: file %f line %l: %m'

    return SyntasticMake({
        \ 'makeprg': l:makeprg,
        \ 'errorformat': l:errorformat,
        \ 'returns': [0, 1] })
endfunction

" register sed syntax checker
if !exists('g:loaded_syntastic_sed_checker') && exists('g:SyntasticRegistry')
    call g:SyntasticRegistry.CreateAndRegisterChecker({
                \ 'filetype': 'sed',
                \ 'name': 'sed'
                \})
    let g:loaded_syntastic_sed_checker = 1
endif
