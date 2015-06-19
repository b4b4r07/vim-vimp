" vimp.vim

if exists('g:loaded_vimp')
    finish
endif
let g:loaded_vimp = 1

command! Vimp call vimp#vimp()
