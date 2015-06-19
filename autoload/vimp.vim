" vimp.vim

scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

let s:true  = 1
let s:false = 0

"if len(findfile("Vimpfile", ".;")) > 0
"  let s:cwd = getcwd()
"  let s:vimp = s:false
"  set runtimepath&
"  execute "set runtimepath+=" . s:cwd
"  execute "set runtimepath+=" . s:cwd . "/.vimp"
"  for plug in split(glob(s:cwd . "/.vimp/*"), '\n')
"    execute 'set runtimepath+=' . plug
"  endfor
"endif

let g:vimp = {
      \ list = ["vim-vimp"],
      \ file = "Vimpfile",
}

let s:cwd = getcwd()
execute "set runtimepath+=" . s:cwd . "/.vimp"
for plug in split(glob(s:cwd . "/.vimp/*"), '\n')
  execute 'set runtimepath+=' . plug
endfor

function! vimp#parse()
  let list = []
  for dep in readfile("Vimpfile")
    if isdirectory(dep)
      let res= fnamemodify(dep, ":p")
      call add(list, res)
    else
      let res = finddir(fnamemodify(dep, ":t"), expand("$HOME/.vim/bundle"))
      if !empty(res)
        call add(list, res)
      endif
    endif
  endfor
  return list
endfunction

function! vimp#symbolic()
  call mkdir(".vimp")
  for link in vimp#parse()
    call system(printf("ln -snf %s .vimp", link))
  endfor
endfunction

function! vimp#list()
  for list in vimp#parse()
    echo list
  endfor
endfunction

function! vimp#gen()
  call writefile(g:vimp.list, g:vimp.file)
endfunction

"__END__ {{{1
let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set et fdm=marker ft=vim ts=2 sw=2 sts=2:
