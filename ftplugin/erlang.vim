" Is use vertical split
if exists("g:vsplit")
	let g:split = 'vertical'
else
	let g:split = ''
endif

" Default open in new tab global function call
if !exists("g:global_call")
	let g:global_call = 2
endif

" Default open in same buffer local function call
if !exists("g:local_call")
	let g:local_call = 0
endif

nnoremap <silent> <buffer> <localleader>d
	\ :call revim#goto#Define(g:local_call, g:global_call)<CR>
