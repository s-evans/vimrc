" define a custom help handler for cmake commands
function! s:ViewDoc_cmake(topic, filetype, synid, ctx)
    return {
                \'cmd':    'man cmake-commands cmake-variables cmake-modules cmake-properties cmake-policies',
                \'ft':     'man',
                \'search': '^[ ]\+' . a:topic,
                \}
endfunction

" configure cmake help
let g:ViewDoc_cmake=[
            \ 'ViewDoc_help_custom',
            \ 'ViewDoc_DEFAULT' ]
