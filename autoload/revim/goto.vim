if !exists("g:erl_top")
	let g:erl_top =
		\ system("escript " . expand('<sfile>:p:h:h:h') . '/scripts/erlang_dir')
endif

function! s:Find(function)
	" reset error message
	let v:errmsg = ""
	execute "silent! keepjumps normal! /^\\V" . a:function . "(\<CR>"
	if v:errmsg != ""
		execute "normal! \<c-o>"
	endif
	let @/ = ""
endfunction

function! s:Create(type, module, function)
	" reset error message
	let v:errmsg = ""
	let l:old_path = &path
	let &path = &path .
		\ ",**/src/**," .
		\ "," . g:erl_top . "*/src/**"

	let l:current = expand('%:t:r')

	if a:type == 0
		" open in same window
		execute "silent! find " . a:module . ".erl"
	elseif a:type == 1
		" open in new window
		execute "silent! " . g:split . " sfind " . a:module . ".erl"
	elseif a:type == 2
		" open in new tab
		execute "silent! tabfind " . a:module . ".erl"
	end
	let &path = l:old_path

	if v:errmsg != ""
		return
	endif

	" we open new file
	keepjumps normal! gg

	call s:Find(a:function)

	if v:errmsg != ""
		" Return where user run goto
		if a:type == 1
			bdelete
		elseif a:type == 2
			tabclose
			tabprevious
		else
			execute "normal! \<c-o>"
		end
	endif
endfunction

function! s:Open(type, module, function)
	let l:module = '\(^\|/\)' . a:module . '\.erl'
	" Try to find existing buffer
	let l:bufnum = bufnr(l:module)
	if l:bufnum != -1
		for i in range(tabpagenr('$'))
			let l:buflist = tabpagebuflist(i + 1)
			if index(l:buflist, l:bufnum) >= 0
				execute "tabnext " . (i + 1)
				break
			endif
		endfor

		let l:window = bufwinnr(l:module)
		if l:window != -1
			execute l:window . "wincmd w"
			normal! gg
			call s:Find(a:function)
		else
			call s:Create(a:type, a:module, a:function)
		endif
	else
		call s:Create(a:type, a:module, a:function)
	endif
endfunction

function! revim#goto#Define(localdefine, globaldefine)
	" regexp for erlang atom
	let l:atom = '\l[a-zA-Z0-9_@]*'

	if a:localdefine > 2 || a:globaldefine > 2
		return
	endif

	" get fun name with module
	setlocal iskeyword+=:
	let l:MF = expand('<cword>')
	setlocal iskeyword-=:

	let l:module = expand('%:t:r')

	if match(l:MF, '\v^' . l:atom . '\:' . l:atom . '$') == 0
		let [l:module, l:function] = split(l:MF, ":")
		if l:module == expand('%:t:r')
			" Same module function call
			let l:type = a:localdefine
		else
			" To other module function call
			let l:type = a:globaldefine
		endif
	elseif match(l:MF, '\v^' . l:atom . '$') == 0
		" local function call
		let l:type = a:localdefine
		let function = l:MF
	end
	call s:Open(l:type, l:module, l:function)
endfunction
