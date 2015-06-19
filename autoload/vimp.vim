" vimp.vim

scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

let s:true  = 1
let s:false = 0

" Put something like this in your vimrc
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
      \ "list": [
      \   "vim-vimp",
      \   "ctrlp.vim",
      \ ],
      \ "dir":  ".vimp",
      \ "file": "Vimpfile",
      \}

function! vimp#parse()
  let list = []
  for dep in readfile("Vimpfile")
  if dep ==# "vim-vimp"
    continue
  endif
    if isdirectory(dep)
      let res = fnamemodify(dep, ":p")
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
  if !isdirectory(g:vimp.dir)
    call mkdir(g:vimp.dir)
  endif

  for link in vimp#parse()
    call system(printf("ln -snf %s %s", link, g:vimp.dir))
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

function! vimp#vimp()
  call vimp#gen()
  call vimp#symbolic()
  call vimp#list()
endfunction

"__END__ {{{1
let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set et fdm=marker ft=vim ts=2 sw=2 sts=2:
