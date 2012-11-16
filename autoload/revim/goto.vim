if !exists("g:erl_top")
	let g:erl_top =
		\ system("escript " . expand('<sfile>:p:h:h:h') . '/scripts/erlang_dir')
endif

function! revim#goto#Define(window)
	let l:atom = '\l[a-zA-Z0-9_@]*'
	let l:old_path = &path

	" get fun name with module
	set iskeyword+=:
	let l:MF = expand('<cword>')
	set iskeyword-=:

	if match(l:MF, '\v^' . l:atom . '\:' . l:atom . '$') == 0
		let [l:module, l:function] = split(l:MF, ":")

		let &path = &path .
			\ ",**/src/**," .
			\ "," . g:erl_top . "*/src/**"
		execute "find " . l:module . ".erl"
		let &path = l:old_path
		keepjumps normal! gg
		execute "keepjumps normal! /^\\V" . l:function . "(\<CR>"
	elseif match(l:MF, '\v^' . l:atom . '$') == 0
		normal! gg
		execute "keepjumps normal! /^\\V" . l:MF . "(\<CR>"
	end
endfunction
