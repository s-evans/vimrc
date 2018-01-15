" adapter for formatexpr to formatting command
function! SqlFormatExpr(start, end)
    silent execute a:start . ',' . a:end . 'SQLUFormatter'
endfunction

" set formatexpr for SQL files
set formatexpr=SqlFormatExpr(v:lnum,v:lnum+v:count-1)
