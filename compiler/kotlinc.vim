" Vim compiler file
" Compiler:	kotlinc

if exists("current_compiler")
  finish
endif
let current_compiler = "kotlinc"

if exists(":CompilerSet") != 2		" older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet makeprg=kotlinc

CompilerSet errorformat=%t:\ %f:\ (%l\\\,\ %c):\ %m
