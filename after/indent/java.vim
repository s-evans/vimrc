setlocal indentexpr=GetJavaIndent()

function! s:SkipJavaBlanksAndComments(startline)
  let l:lnum = a:startline
  while l:lnum > 1
    let l:lnum = prevnonblank(l:lnum)
    if getline(l:lnum) =~# '\*/\s*$'
      while getline(l:lnum) !~# '/\*' && l:lnum > 1
        let l:lnum = l:lnum - 1
      endwhile
      if getline(l:lnum) =~# '^\s*/\*'
        let l:lnum = l:lnum - 1
      else
        break
      endif
    elseif getline(l:lnum) =~# '^\s*//'
      let l:lnum = l:lnum - 1
    else
      break
    endif
  endwhile
  return l:lnum
endfunction

function! GetJavaIndent()

  " Java is just like C; use the built-in C indenting and then correct a few
  " specific cases.
  let l:theIndent = cindent(v:lnum)

  " If we're in the middle of a comment then just trust cindent
  if getline(v:lnum) =~# '^\s*\*'
    return l:theIndent
  endif

  " find start of previous line, in case it was a continuation line
  let l:lnum = s:SkipJavaBlanksAndComments(v:lnum - 1)

  " If the previous line starts with '@', we should have the same indent as
  " the previous one
  if getline(l:lnum) =~# '^\s*@.*$'
    return indent(l:lnum)
  endif

  let l:prev = l:lnum
  while l:prev > 1
    let l:next_prev = s:SkipJavaBlanksAndComments(l:prev - 1)
    if getline(l:next_prev) !~# ',\s*$'
      break
    endif
    let l:prev = l:next_prev
  endwhile

  " Try to align "throws" lines for methods and "extends" and "implements" for
  " classes.
  if getline(v:lnum) =~# '^\s*\(throws\|extends\|implements\)\>'
        \ && getline(l:lnum) !~# '^\s*\(throws\|extends\|implements\)\>'
    let l:theIndent = l:theIndent + shiftwidth()
  endif

  " correct for continuation lines of "throws", "implements" and "extends"
  let l:cont_kw = matchstr(getline(l:prev),
        \ '^\s*\zs\(throws\|implements\|extends\)\>\ze.*,\s*$')
  if strlen(l:cont_kw) > 0
    let l:amount = strlen(l:cont_kw) + 1
    if getline(l:lnum) !~# ',\s*$'
      let l:theIndent = l:theIndent - (l:amount + shiftwidth())
      if l:theIndent < 0
        let l:theIndent = 0
      endif
    elseif l:prev == l:lnum
      let l:theIndent = l:theIndent + l:amount
      if l:cont_kw ==# 'throws'
        let l:theIndent = l:theIndent + shiftwidth()
      endif
    endif
  elseif getline(l:prev) =~# '^\s*\(throws\|implements\|extends\)\>'
        \ && (getline(l:prev) =~# '{\s*$'
        \  || getline(v:lnum) =~# '^\s*{\s*$')
    let l:theIndent = l:theIndent - shiftwidth()
  endif

  " Below a line starting with "}" never indent more.  Needed for a method
  " below a method with an indented "throws" clause.
  let l:lnum = s:SkipJavaBlanksAndComments(v:lnum - 1)
  if getline(l:lnum) =~# '^\s*}\s*\(//.*\|/\*.*\)\=$' && indent(l:lnum) < l:theIndent
    let l:theIndent = indent(l:lnum)
  endif

  return l:theIndent
endfunction
