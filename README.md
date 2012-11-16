revim
=====

Erlang + Rebar plugin for vim

GOTO
====

For quick goto from function call to it declaration you can use
``<localleader>d`` or you can set up own mapping:

```viml
autocmd FileType erlang nnoremap <silent> <buffer>
	\ <F6> :call revim#goto#Define(g:global_call)<CR>
```

There is 2 type of function call: global (whith module name) and local. Local
function call always open in current buffer. For global call you can specified
how to process move to declaration. Exists 3 type of goto:
  * 0 = in same buffer (move cursor, if declaration in other file, than first
	open it)
  * 1 = in split window (split window and in new window goto declaration)
  * 2 = in new tab (open new tab and goto declaration)

Example:
 * Goto local function in same buffer and global function in new tab (default)

   ```viml
   let g:global_call = 2
   ```

Goto smart enjoy to not open new window for already opened file. It simple go
to that buffer and move cursor to function declaration.

Highlight syntax
================

Highlight correct erlang expressions and some common errors.

Settings
--------

In you .vimrc you can change color for some of erlang expressions:

* different highlighting for function heads

  ```viml
  hi erlangFunHead cterm=bold
  ```

* highlight edoc tags:

  ```viml
  hi erlangEdocTag cterm=bold
  ```

* highlight erlang BIF:

  ```viml
  hi erlangBIF cterm=bold ctermfg=green
  ```
