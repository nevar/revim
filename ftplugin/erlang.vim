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

nnoremap <silent> <buffer> <localleader>d
	\ :call revim#goto#Define(g:global_call)<CR>
