" awk indent script modified to properly handle '} else {'

setlocal indentexpr=MyGetAwkIndent()

" This function contains a lot of exit points. It checks for simple cases
" first to get out of the function as soon as possible, thereby reducing the
" number of possibilities later on in the difficult parts

function! MyGetAwkIndent()

    " Find previous line and get it's indentation
    let l:prev_lineno = s:Get_prev_line( v:lnum )
    if l:prev_lineno == 0
        return 0
    endif
    let l:prev_data = getline( l:prev_lineno )
    let l:ind = indent( l:prev_lineno )

    " Increase indent if the previous line contains an opening brace. Search
    " for this brace the hard way to prevent errors if the previous line is a
    " 'pattern { action }' (simple check match on /{/ increases the indent then)

    if s:Get_brace_balance( l:prev_data, '{', '}' ) > 0
        " Don't increase indent if this line completes a brace context
        if getline(v:lnum) =~# '^\s*}'
            return l:ind
        endif
        return l:ind + &shiftwidth
    endif

    let l:brace_balance = s:Get_brace_balance( l:prev_data, '(', ')' )

    " If prev line has positive brace_balance and starts with a word (keyword
    " or function name), align the current line on the first '(' of the prev
    " line

    if l:brace_balance > 0 && s:Starts_with_word( l:prev_data )
        return s:Safe_indent( l:ind, s:First_word_len(l:prev_data), getline(v:lnum))
    endif

    " If this line starts with an open brace bail out now before the line
    " continuation checks.

    if getline( v:lnum ) =~# '^\s*{'
        return l:ind
    endif

    " If prev line seems to be part of multiline statement:
    " 1. Prev line is first line of a multiline statement
    "    -> attempt to indent on first ' ' or '(' of prev line, just like we
    "       indented the positive brace balance case above
    " 2. Prev line is not first line of a multiline statement
    "    -> copy indent of prev line

    let l:continue_mode = s:Seems_continuing( l:prev_data )
    if l:continue_mode > 0
        if s:Seems_continuing( getline(s:Get_prev_line( l:prev_lineno )) )
            " Case 2
            return l:ind
        else
            " Case 1
            if l:continue_mode == 1
                " Need continuation due to comma, backslash, etc
                return s:Safe_indent( l:ind, s:First_word_len(l:prev_data), getline(v:lnum))
            else
                " if/for/while without '{'
                return l:ind + &shiftwidth
            endif
        endif
    endif

    " If the previous line doesn't need continuation on the current line we are
    " on the start of a new statement.  We have to make sure we align with the
    " previous statement instead of just the previous line. This is a bit
    " complicated because the previous statement might be multi-line.
    "
    " The start of a multiline statement can be found by:
    "
    " 1 If the previous line contains closing braces and has negative brace
    "   balance, search backwards until cumulative brace balance becomes zero,
    "   take indent of that line
    " 2 If the line before the previous needs continuation search backward
    "   until that's not the case anymore. Take indent of one line down.

    " Case 1
    if l:prev_data =~# ')' && l:brace_balance < 0
        while l:brace_balance != 0 && l:prev_lineno > 0
            let l:prev_lineno = s:Get_prev_line( l:prev_lineno )
            let l:prev_data = getline( l:prev_lineno )
            let l:brace_balance=l:brace_balance+s:Get_brace_balance(l:prev_data,'(',')' )
        endwhile
        let l:ind = indent( l:prev_lineno )
    else
        " Case 2
        if s:Seems_continuing( getline( l:prev_lineno - 1 ) )
            let l:prev_lineno = l:prev_lineno - 2
            let l:prev_data = getline( l:prev_lineno )
            while l:prev_lineno > 0 && (s:Seems_continuing( l:prev_data ) > 0)
                let l:prev_lineno = s:Get_prev_line( l:prev_lineno )
                let l:prev_data = getline( l:prev_lineno )
            endwhile
            let l:ind = indent( l:prev_lineno + 1 )
        endif
    endif

    " Decrease indent if this line contains a '}'.
    if getline(v:lnum) =~# '^\s*}'
        let l:ind = l:ind - &shiftwidth
    endif

    return l:ind
endfunction

" Find the open and close braces in this line and return how many more open-
" than close braces there are. It's also used to determine cumulative balance
" across multiple lines.

function! s:Get_brace_balance( line, b_open, b_close )
    let l:start_idx = stridx(a:line, a:b_open)
    let l:mod_line = a:line[l:start_idx :]
    let l:line2 = substitute( l:mod_line, a:b_open, '', 'g' )
    let l:openb = strlen( l:mod_line ) - strlen( l:line2 )
    let l:line3 = substitute( l:line2, a:b_close, '', 'g' )
    let l:closeb = strlen( l:line2 ) - strlen( l:line3 )
    return l:openb - l:closeb
endfunction

" Find out whether the line starts with a word (i.e. keyword or function
" call). Might need enhancements here.

function! s:Starts_with_word( line )
    if a:line =~# '^\s*[a-zA-Z_0-9]\+\s*('
        return 1
    endif
    return 0
endfunction

" Find the length of the first word in a line. This is used to be able to
" align a line relative to the 'print ' or 'if (' on the previous line in case
" such a statement spans multiple lines.
" Precondition: only to be used on lines where 'Starts_with_word' returns 1.

function! s:First_word_len( line )
    let l:white_end = matchend( a:line, '^\s*' )
    if match( a:line, '^\s*func' ) != -1
        let l:word_end = matchend( a:line, '[a-z]\+\s\+[a-zA-Z_0-9]\+[ (]*' )
    else
        let l:word_end = matchend( a:line, '[a-zA-Z_0-9]\+[ (]*' )
    endif
    return l:word_end - l:white_end
endfunction

" Determine if 'line' completes a statement or is continued on the next line.
" This one is far from complete and accepts illegal code. Not important for
" indenting, however.

function! s:Seems_continuing( line )
    " Unfinished lines
    if a:line =~# '\(--\|++\)\s*$'
        return 0
    endif
    if a:line =~# '[\\,\|\&\+\-\*\%\^]\s*$'
        return 1
    endif
    " if/for/while (cond) eol
    if a:line =~# '^\s*\(if\|while\|for\)\s*(.*)\s*$' || a:line =~# '^\s*else\s*'
        return 2
    endif
    return 0
endfunction

" Get previous relevant line. Search back until a line is that is no
" comment or blank and return the line number

function! s:Get_prev_line( lineno )
    let l:lnum = a:lineno - 1
    let l:data = getline( l:lnum )
    while l:lnum > 0 && (l:data =~# '^\s*#' || l:data =~# '^\s*$')
        let l:lnum = l:lnum - 1
        let l:data = getline( l:lnum )
    endwhile
    return l:lnum
endfunction

" This function checks whether an indented line exceeds a maximum linewidth
" (hardcoded 80). If so and it is possible to stay within 80 positions (or
" limit num of characters beyond linewidth) by decreasing the indent (keeping
" it > base_indent), do so.

function! s:Safe_indent( base, wordlen, this_line )
    let l:line_base = matchend( a:this_line, '^\s*' )
    let l:line_len = strlen( a:this_line ) - l:line_base
    let l:indent = a:base
    if (l:indent + a:wordlen + l:line_len) > 80
        " Simple implementation good enough for the time being
        let l:indent = l:indent + 3
    endif
    return l:indent + a:wordlen
endfunction
