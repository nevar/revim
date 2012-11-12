revim
=====

Erlang + Rebar plugin for vim

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
