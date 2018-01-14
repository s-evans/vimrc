" help settings
let g:ViewDoc_cs=[ 'ViewDoc_DEFAULT', 'ViewDoc_help_custom', function('ViewDoc_hlpviewer') ]

" astyle support
if executable('astyle')
    let b:format_prg = 'astyle --mode=cs'
endif

" file path search support
set suffixesadd=.cs

" comment string settings
let b:commentary_format='// %s'
