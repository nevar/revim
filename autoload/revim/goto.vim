if !exists("g:erl_top")
	let g:erl_top =
		\ system("escript " . expand('<sfile>:p:h:h:h') . '/scripts/erlang_dir')
endif

function! s:Find(MFA)
	" with arity
	let l:witharity = '^\V' . a:MFA.function . '(' .
		\ join(repeat(['\.\*'], a:MFA['arity']), ',') . ')'
	" without arity
	let l:withoutarity = '^\V' . a:MFA.function . '('

	for pattern in [l:witharity, l:withoutarity]
		" reset error message
		let v:errmsg = ""
		execute 'silent! keepjumps normal! /' . pattern . "\<CR>"
		if v:errmsg == ""
			break
		end
	endfor
	if v:errmsg != ""
		execute "silent normal! \<c-o>"
	endif
	let @/ = ""
endfunction

function! s:Create(type, MFA)
	" reset error message
	let v:errmsg = ""
	let l:old_path = &path
	let &path = &path .
		\ ",**/src/**," .
		\ "," . g:erl_top . "*/src/**"

	if a:type == 0
		" open in same window
		execute "silent! find " . a:MFA.module . ".erl"
	elseif a:type == 1
		" open in new window
		execute "silent! " . g:split . " sfind " . a:MFA.module . ".erl"
	elseif a:type == 2
		" open in new tab
		execute "silent! tabfind " . a:MFA.module . ".erl"
	end
	let &path = l:old_path

	if v:errmsg != ""
		return
	endif

	" we open new file
	keepjumps normal! gg
	call s:Find(a:MFA)

	if v:errmsg != ""
		" return where user run goto
		if a:type == 1
			bdelete
		elseif a:type == 2
			tabclose
			tabprevious
		end
	endif
endfunction

function! s:Open(type, MFA)
	let l:module = '\(^\|/\)' . a:MFA.module . '\.erl'
	" try to find existing buffer
	let l:bufnum = bufnr(l:module)
	if l:bufnum != -1
		" foreach tab
		for i in range(tabpagenr('$'))
			" try find buffer
			let l:buflist = tabpagebuflist(i + 1)
			if index(l:buflist, l:bufnum) >= 0
				" Buffer exists on that tab
				" Goto that tab
				execute "tabnext " . (i + 1)
				break
			endif
		endfor

		let l:window = bufwinnr(l:module)
		if l:window != -1
			" we found buffer goto that buffer
			execute l:window . "wincmd w"
			normal! gg
			call s:Find(a:MFA)
		else
			call s:Create(a:type, a:MFA)
		endif
	else
		call s:Create(a:type, a:MFA)
	endif
endfunction

function s:CountArgs()
	let l:line = strpart(getline('.'), col('.'))
	let l:inside = 0
	let l:i = 0
	let l:arity = 1
	let l:lnum = line('.')
	while 1
		if l:i > strlen(l:line)
			" Get next line
			let l:lnum += 1
			let l:line = getline(nextnonblank(l:lnum))
			let l:i = 0
		elseif l:inside == 0 && l:line[l:i] == ')'
			" found close of function call
			break
		elseif l:inside == 0 && l:line[l:i] == ','
			" function argument
			let l:arity += 1
		elseif l:inside > 0 && l:line[l:i] == ')'
			" found close of function call in argument
			let l:inside -= 1
		elseif l:line[l:i] == '('
			" start of function call in argument
			let l:inside += 1
		elseif l:line[l:i : l:i + 4] ==# 'fun('
			" lambda function begin
			let l:inside += 1
		elseif l:line[l:i : l:i + 3] ==# 'end'
			" lambda function end
			let l:inside -= 1
		endif
		let l:i += 1
	endwhile

	return l:arity
endfunction

function! s:MFA()
	let l:MFA = {}
	let l:column = col('.')
	let l:position = getpos('.')

	" get fun name with module
	setlocal iskeyword+=:
	let l:MF = expand('<cword>')
	normal! w
	setlocal iskeyword-=:

	let l:line = strpart(getline('.'), col('.') - 1)
	" count function arguments
	if l:line =~ '\v^\(\)'
		let l:MFA.arity = 0
	elseif l:line =~ '\v^\('
		let l:MFA.arity = s:CountArgs()
	elseif l:line =~ '\v^\/'
		let l:MFA.arity = strpart(l:line, 1) + 0
	else
		call setpos('.', l:position)
		return {}
	endif

	call setpos('.', l:position)

	" regexp for erlang atom
	let l:atom = '\l[a-zA-Z0-9_@]*'

	if match(l:MF, '\v^' . l:atom . '\:' . l:atom . '$') == 0
		let [l:module, l:function] = split(l:MF, ":")
		let l:MFA.function = l:function
		if l:module != expand('%:t:r')
			" To other module function call
			let l:MFA.module = l:module
		endif
	elseif match(l:MF, '\v^' . l:atom . '$') == 0
		" local function call
		let l:MFA.function = l:MF
	elseif
		return {}
	end

	return l:MFA
endfunction

function! revim#goto#Define(globaldefine)
	if a:globaldefine > 2 || a:globaldefine < 0
		return
	endif

	let l:MFA = s:MFA()

	if l:MFA == {}
		return
	elseif has_key(l:MFA, 'module')
		" to other module function call
		call s:Open(a:globaldefine, l:MFA)
	else
		" local function call
		normal! gg
		call s:Find(l:MFA)
	endif
endfunction
