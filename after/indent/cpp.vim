" reset cinoptions
set cinoptions=

" do not indent access specifiers
set cinoptions+=g0

" do not indent namespaces
set cinoptions+=N-s

" do not indent case labels
set cinoptions+=:0

" closing brace reduces indent level (fixes lambdas)
set cinoptions+=j1

" do not add continuation indent to multiline comma delimited lists (broken by j1)
set cinoptions+=J1

" make open parens at eol increment indent level by exactly 1 shiftwidth
set cinoptions+=(1s

" make open parens at start of line behave the same as at eol
set cinoptions+=U1

" make closing parens at the start of a line reduce the indent scope
set cinoptions+=m1s

" don't indent return types
set cinoptions+=t0

function! CppIndent()
    if v:lnum == 0
        return 0
    endif

    let l:cur_data = getline(v:lnum)
    let l:cur_cidt = cindent(v:lnum)
    let l:prev_line = v:lnum-1
    let l:prev_data = getline(l:prev_line)
    let l:prev_aidt = indent(l:prev_line)

    " handle function templates
    if l:prev_data =~# '^\s*template\s*<'
        return l:prev_aidt
    endif

    " skip this case (namespace operator)
    if l:cur_data =~# '^\s*::' || l:cur_data =~# '::\s*$'
        return l:cur_cidt
    endif

    " beginning with single colon (member init)
    if l:cur_data =~# '^\s*:\s*'
        return l:cur_cidt + &shiftwidth
    endif

    " beginning with single comma (member init)
    if l:cur_data =~# '^\s*,\s'
        return l:prev_aidt
    endif

    " all other cases
    return l:cur_cidt
endfunction

setlocal indentexpr=CppIndent()
