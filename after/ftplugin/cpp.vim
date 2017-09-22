" viewdoc support
let g:ViewDoc_cpp=[ 'ViewDoc_DEFAULT', 'ViewDoc_help_custom', function('ViewDoc_hlpviewer') ]

" clang-format support
if executable('clang-format')
    let b:format_prg = 'clang-format -style=file'
endif

" astyle support
if executable('astyle')
    let b:format_prg = 'astyle'
endif

" file path search support
set suffixesadd=.hpp,.hh,.hxx,.h,.cpp,.c++,cxx,.cc,.c

" comment string settings
let b:commentary_format='// %s'
