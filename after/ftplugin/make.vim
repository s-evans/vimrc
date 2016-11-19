" remove existing variable to avoid a type error
unlet g:ViewDoc_make

" configure viewdoc for makefiles
let g:ViewDoc_make=[ 'ViewDoc_help_custom', 'ViewDoc_search', 'ViewDoc_DEFAULT' ]
