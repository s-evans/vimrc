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
