setlocal indentexpr=GetJavaIndent()

function! s:SkipJavaBlanksAndComments(startline)
  let lnum = a:startline
  while lnum > 1
    let lnum = prevnonblank(lnum)
    if getline(lnum) =~# '\*/\s*$'
      while getline(lnum) !~# '/\*' && lnum > 1
        let lnum = lnum - 1
      endwhile
      if getline(lnum) =~# '^\s*/\*'
        let lnum = lnum - 1
      else
        break
      endif
    elseif getline(lnum) =~# '^\s*//'
      let lnum = lnum - 1
    else
      break
    endif
  endwhile
  return lnum
endfunction

function! GetJavaIndent()

  " Java is just like C; use the built-in C indenting and then correct a few
  " specific cases.
  let theIndent = cindent(v:lnum)

  " If we're in the middle of a comment then just trust cindent
  if getline(v:lnum) =~# '^\s*\*'
    return theIndent
  endif

  " find start of previous line, in case it was a continuation line
  let lnum = s:SkipJavaBlanksAndComments(v:lnum - 1)

  " If the previous line starts with '@', we should have the same indent as
  " the previous one
  if getline(lnum) =~# '^\s*@.*$'
    return indent(lnum)
  endif

  let prev = lnum
  while prev > 1
    let next_prev = s:SkipJavaBlanksAndComments(prev - 1)
    if getline(next_prev) !~# ',\s*$'
      break
    endif
    let prev = next_prev
  endwhile

  " Try to align "throws" lines for methods and "extends" and "implements" for
  " classes.
  if getline(v:lnum) =~# '^\s*\(throws\|extends\|implements\)\>'
        \ && getline(lnum) !~# '^\s*\(throws\|extends\|implements\)\>'
    let theIndent = theIndent + shiftwidth()
  endif

  " correct for continuation lines of "throws", "implements" and "extends"
  let cont_kw = matchstr(getline(prev),
        \ '^\s*\zs\(throws\|implements\|extends\)\>\ze.*,\s*$')
  if strlen(cont_kw) > 0
    let amount = strlen(cont_kw) + 1
    if getline(lnum) !~# ',\s*$'
      let theIndent = theIndent - (amount + shiftwidth())
      if theIndent < 0
        let theIndent = 0
      endif
    elseif prev == lnum
      let theIndent = theIndent + amount
      if cont_kw ==# 'throws'
        let theIndent = theIndent + shiftwidth()
      endif
    endif
  elseif getline(prev) =~# '^\s*\(throws\|implements\|extends\)\>'
        \ && (getline(prev) =~# '{\s*$'
        \  || getline(v:lnum) =~# '^\s*{\s*$')
    let theIndent = theIndent - shiftwidth()
  endif

  " Below a line starting with "}" never indent more.  Needed for a method
  " below a method with an indented "throws" clause.
  let lnum = s:SkipJavaBlanksAndComments(v:lnum - 1)
  if getline(lnum) =~# '^\s*}\s*\(//.*\|/\*.*\)\=$' && indent(lnum) < theIndent
    let theIndent = indent(lnum)
  endif

  return theIndent
endfunction
