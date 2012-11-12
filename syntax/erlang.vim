" Vim syntax file
" Language:   Erlang
" Maintainer: Yurin Slava <v.yurin@office.ngs.ru>
" Maintainer: Seletskiy Stanislav <s.seletskiy@office.ngs.ru>
" Version:    1.0.0
" -----------------------------------------------------------------------------

if exists("b:current_syntax")
  finish
endif

syntax clear

" Add ? as keyword part for macro
set iskeyword+=?
" Add @ as keyword part for variable
set iskeyword+=@-@

" Comments
syn keyword erlangTodo FIXME TODO contained

syn match erlangInComment   "\v\%.*$"
	\ contains=erlangTodo,@Spell
syn match erlangComment     "\v^\%.*$"
	\ contains=erlangTodo,@Spell
syn match erlangEdocComment "\v^\%{2,3}.*$"
	\ contains=erlangEdocTag,@Spell

syn cluster erlangSimpleExpr add=erlangInComment

" EDoc tags {{{1
syn match erlangEdocUnknownTag "\v\w+" contained

syn keyword erlangEdocTags
	\ @clear @docfile @end @headerfile @type @todo @TODO @author @see @doc
	\ @since @title @version @spec @copyright @deprecated @hidden @private
	\ @equiv @throws @reference
	\ contained transparent

syn match erlangEdocTag "\v^\%{2,3}\s*\@\w+"
	\ contains=erlangEdocUnknownTag,erlangEdocTags
	\ display contained

" Attribute
syn keyword erlangAttribute
	\ behavior module export import  contained import_type compile record file
	\ behaviour export_type spec type opaque
	\ contained

syn keyword erlangPPAttribute
	\ define undef ifdef ifndef else endif include include_lib
	\ contained

syn region erlangCustomAttribute
	\ start="\v^-\l[a-zA-Z0-9@_]*"ms=s+1 end="\v\."
	\ contains=@erlangSimpleExpr
syn region erlangBehaviorAttribute
	\ start="\v^-behaviou?r\("           end="\v\)\."
	\ contains=erlangAttribute,erlangAtom
syn region erlangModuleAttribute
	\ start="\v^-module\("                end="\v\)\."
	\ contains=erlangAttribute,erlangIdentifier,erlangAtom
syn region erlangExportAttribute
	\ start="\v^-export(_type)?\(\["   end="\v\]\)\."
	\ contains=erlangAttribute,erlangFunctionName
syn region erlangImportAttribute
	\ start="\v^-import(_type)?\("     end="\v\)\."
	\ contains=erlangAttribute,erlangFunctionName,erlangAtom
syn region erlangSpecAttribute
	\ start="^-spec"                   end="\."
	\ contains=erlangAttribute,erlangType,erlangAtom,erlangIdentifier,erlangSpecDelimiter,erlangClauseBegin
syn region erlangRecordAttribute
	\ start="^-record("                end="\v\)\."
	\ contains=erlangAttribute,erlangSpecDelimiter,erlangAtom,erlangString,erlangNumber,erlangType,erlangInComment,erlangOperator
syn region erlangTypeAttribute
	\ start="\v^-(type|opaque)"        end="\v\."
	\ contains=erlangAttribute,erlangType,erlangAtom,erlangIdentifier,erlangSpecDelimiter,erlangNumber,erlangInComment,erlangOperator
syn region erlangFileAttribute
	\ start="^-file("                  end=")\."
	\ contains=erlangAttribute,erlangNumber,erlangString
syn region erlangCustomAttribute
	\ start="^-compile("               end=")\."
	\ contains=erlangAttribute,erlangTuple
syn region erlangMacrosDefine
	\ start="^-define(" end=")\."
	\ contains=erlangPPAttribute,@erlangExpr,erlangMacroString
syn region erlangMacrosPreCondit
	\ start="^-undef(" end=")\."
	\ contains=erlangPPAttribute,erlangIdentifier,erlangAtom
syn region erlangMacrosPreCondit
	\ start="\v^-ifn?def\(" end="\v\)\."
	\ contains=erlangPPAttribute,erlangIdentifier,erlangAtom
syn region erlangMacrosInclude
	\ start="^-include("     end=")\."
	\ contains=erlangPPAttribute,erlangString
syn region erlangMacrosInclude
	\ start="^-include_lib(" end=")\."
	\ contains=erlangPPAttribute,erlangString

syn match erlangMacrosPreCondit "^-else\."  display contains=erlangPPAttribute
syn match erlangMacrosPreCondit "^-endif\." display contains=erlangPPAttribute

" Number
syn match erlangNumber "\v<[0-9]+>"                           display contained
syn match erlangNumber "\v<[0-9]+\.[0-9]+(e(\+|\-)?[0-9]+)?>" display contained
syn match erlangNumber "\v<[0-9]+\#[0-9a-fA-F]+>"             display contained

syn cluster erlangSimpleExpr add=erlangNumber

" Atom
syn match  erlangAtom "\v<\l[a-zA-Z0-9@_]*>" display contained
syn region erlangAtom start=/'/ skip=/\\'/ end=/'/ display contained

syn cluster erlangSimpleExpr add=erlangAtom

" Variable
syn match erlangIdentifier "\v<(\u|_)[a-zA-Z0-9@_]*>" display contained

syn cluster erlangSimpleExpr add=erlangIdentifier

" Macro
syn match erlangMacro       "\v<\?[a-zA-Z_][a-zA-Z0-9@_]*>"   display contained
syn match erlangMacroString "\v<\?\?[a-zA-Z_][a-zA-Z0-9@_]*>" display contained

syn cluster erlangSimpleExpr add=erlangMacro

" String
syn region erlangString
	\ start=/"/ skip=/\\"/ end=/"/
	\ contained contains=erlangSpecialChar

syn cluster erlangSimpleExpr add=erlangString

syn match  erlangChar "\v\$."            display contained
syn match  erlangChar "\v\$\\."          display contained
	\ contains=erlangSpecialChar
syn match  erlangChar "\v\$\\[0-7]{1,3}" display contained
	\ contains=erlangSpecialChar

syn cluster erlangSimpleExpr add=erlangChar

syn match  erlangSpecialChar "\v\\(b|d|e|f|n|r|s|t|v|\\|'|\")" display contained
syn match  erlangSpecialChar "\v\\[0-7]{1,3}"                  display contained

" FunctionName
syn match erlangFunctionName
	\ "\v\l[a-zA-Z0-9@_]*/[0-9]+"
	\ display contains=erlangNumber,erlangAtom contained

syn keyword erlangFunKeyword fun contained

syn match erlangFunReference
	\ "\vfun (\l[a-zA-Z0-9@_]*\:)?\l[a-zA-Z0-9@_]*/[0-9]+"
	\ display contains=erlangNumber,erlangFunKeyword,erlangAtom contained
syn match erlangFunReference
	\ "\vfun (\l[a-zA-Z0-9@_]*\:)?\'([^\\']*(\\\'[^\\']*)*)\'/[0-9]+"
	\ display contains=erlangNumber,erlangAtom contained

syn cluster erlangExpr add=erlangFunReference

" Erlang types
let s:types = ["any", "none", "pid", "port", "reference", "float", "atom",
	\ "binary", "fun", "integer", "list", "tuple", "term", "boolean", "byte",
	\ "char", "non_neg_integer", "pos_integer", "neg_integer", "number", "list",
	\ "maybe_improper_list", "string", "nonempty_string", "iolist", "module",
	\ "mfa", "node", "timeout", "no_return", "nonempty_maybe_improper_list",
	\ "nonempty_improper_list", "nonempty_maybe_improper_list"]

execute 'syn match erlangType "\v:@<!<(' . join(s:types, "|") .
	\ ')(\(&)" display contained'

" Records
syn match erlangRecordDel '#\|\.' display contained
syn match erlangRecord "\v\#\l[a-zA-Z0-9@_]*(\.\l[a-zA-Z0-9@_]*)?"
	\ display contains=erlangRecordDel,erlangAtom contained

syn cluster erlangSimpleExpr add=erlangRecord

" Operators
syn match   erlangOperator "\v\+|\-|\*|\/|\=|\>|\<|\!" display contained
syn match   erlangOperator "==\|\/=\|=:=\|=\/=\|=<\|>=" display contained
syn match   erlangOperator "++" display contained

syn keyword erlangOperator
	\ div rem or xor bor bxor bsl bsr and band not bnot orelse andalso
	\ contained

syn cluster erlangSimpleExpr add=erlangOperator

" Delimiter
syn match erlangSpecDelimiter '::' display contained

" Commom erlang error
syn match erlangError "\v\[|\{|]|}" contained
syn match erlangError "\v\,[ \n\t]*\," contained
syn match erlangError "\v\,[ \n\t]*((]|}|\))&)" contained
syn match erlangError "\v(\;|\,)[ \n\t]*(<end>&)" contained

syn cluster erlangSimpleExpr add=erlangError

syn match erlangComprehensions "\v\|\|" display contained

" Erlang list
syn match erlangListDel '|' display contained
syn region erlangList
	\ matchgroup=None
	\ start="\v\[" end="\v\]"
	\ contained contains=@erlangExpr,erlangListDel,erlangComprehensions

syn cluster erlangSimpleExpr add=erlangList

" Binary
syn region erlangBinary
	\ matchgroup=erlangBinary
	\ start="\v\<\<" end="\v\>\>"
	\ contained contains=@erlangExpr,erlangComprehensions

syn cluster erlangSimpleExpr add=erlangBinary

" Erlang tuple
syn region erlangTuple
	\ matchgroup=None
	\ start="\v\{" end="\v\}"
	\ contains=@erlangExpr

syn cluster erlangSimpleExpr add=erlangTuple

" Erlang BIF
" List of BIF in erlangs:
" erl -man erlang | grep "^\s\{7\}\w\+(" | cut -f1 -d\( | tail -n+4
let s:bif = [
	\ "abs", "apply", "atom_to_binary", "atom_to_list", "binary_part",
	\ "binary_to_atom", "binary_to_existing_atom", "binary_to_list",
	\ "binary_to_term", "bit_size", "bitstring_to_list", "byte_size",
	\ "check_process_code", "concat_binary", "date", "delete_module",
	\ "demonitor", "disconnect_node", "element", "erase", "error", "exit",
	\ "float", "float_to_list", "garbage_collect", "get", "get_keys",
	\ "group_leader", "halt", "hd", "integer_to_list", "iolist_size",
	\ "iolist_to_binary", "is_alive", "is_atom", "is_binary", "is_bitstring",
	\ "is_boolean", "is_float", "is_function", "is_integer", "is_list",
	\ "is_number", "is_pid", "is_port", "is_process_alive", "is_record",
	\ "is_reference", "is_tuple", "length", "link", "list_to_atom",
	\ "list_to_binary", "list_to_bitstring", "list_to_existing_atom",
	\ "list_to_float", "list_to_integer", "list_to_pid", "list_to_tuple",
	\ "load_module", "make_ref", "max", "min", "module_loaded", "monitor",
	\ "monitor_node", "node", "nodes", "now", "open_port", "pid_to_list",
	\ "port_close", "port_command", "port_connect", "port_control",
	\ "pre_loaded", "process_flag", "process_info", "processes", "purge_module",
	\ "put", "register", "registered", "round", "self", "setelement", "size",
	\ "spawn", "spawn_link", "spawn_monitor", "spawn_opt", "split_binary",
	\ "statistics", "term_to_binary", "throw", "time", "tl", "trunc",
	\ "tuple_size", "tuple_to_list", "unlink", "unregister", "whereis"]

execute 'syn match erlangBIF "\v((erlang\:)@<=|:@<!)<('. join(s:bif, '|') .
	\ ')>(\(&)" contained'

syn cluster erlangExpr add=erlangBIF

" Erlang Guard BIF
"erl -man erlang | tac | grep "\(^\s\{7\}\w\+(\|Allowed in guard tests\)" |
"sed -n "/Allowed in guard tests/ {
"n
"p
"}" | cut -f1 -d\( | tail -n+4
let s:guard = [
	\ "abs", "binary_part", "bit_size", "byte_size", "element", "float", "hd",
	\ "is_atom", "is_binary", "is_bitstring", "is_boolean", "is_float",
	\ "is_function", "is_integer", "is_list", "is_number", "is_pid", "is_port",
	\ "is_record", "is_reference", "is_tuple", "length", "node", "round",
    \ "self", "size"]

execute 'syn match erlangGuardBIF "\v((erlang\:)@<=|:@<!)<('.
	\ join(s:guard, '|') . ')>(\(&)" display contained'

" Function Guard
syn region erlangGuard
	\ matchgroup=erlangGuard
	\ start=/when/ end="\v(\-\>&)"
	\ contains=@erlangExpr,erlangGuardBIF contained


" Block
syn region erlangBlock
	\ matchgroup=erlangBlock
	\ start="\v<begin>" end="\v<end>"
	\ contains=@erlangExpr contained

syn cluster erlangExpr add=erlangBlock

" Case
" Add & for end of region for erlangCaseClause can start his region
syn region erlangCaseBlock
	\ matchgroup=erlangCase
	\ start="\v<case>" end="\v(<of>&)"
	\ nextgroup=erlangCaseClause
	\ contains=@erlangExpr contained

syn cluster erlangExpr add=erlangCaseBlock

syn region erlangCaseClause
	\ matchgroup = erlangCase
	\ start="\v<of>" end="\v<end>"
	\ contains=@erlangExpr,erlangGuard,erlangLambdaFunBody contained

" If
syn region erlangIfBlock
	\ matchgroup=erlangIf
	\ start="\<if\>" end="\<end\>"
	\ contains=erlangLambdaFunBody,erlangGuardBIF,@erlangSimpleExpr contained

syn cluster erlangExpr add=erlangIfBlock

syn match erlangClauseBegin '->' display contained

" Receive
syn keyword erlangAfter after contained

syn region erlangReceiveBody
	\ start="\v\-\>" end="\v\;" end="\v(<end>&)" end="\v(<after>&)"
	\ contains=@erlangExpr,erlangClauseBegin contained

syn region erlangReceiveBlock
	\ matchgroup=erlangReceive
	\ start="\v<receive>" end="\v<end>"
	\ contains=@erlangExpr,erlangGuard,erlangReceiveBody,erlangAfter contained

syn cluster erlangExpr add=erlangReceiveBlock

" Function
syn region erlangFun
	\ matchgroup=erlangFunHead
	\ start="\v^\l[0-9A-Za-z_-]*(\(&)"
	\ start="\v^\'[^\\']*(\\\'[^\\']*)*\'(\(&)" end="\v\-\>&"
	\ nextgroup=erlangFunBody contains=erlangFunArg,erlangGuard

syn region erlangFunArg
	\ start="\v\(" end="\v\)" contains=@erlangExpr contained

syn region erlangFunBody
	\ start="\v\-\>" end="\v\;$" end="\v\.$"
	\ contains=@erlangExpr,erlangClauseBegin contained

" Lambda function
syn region erlangLambdaFun
	\ matchgroup=erlangFunKeyword
	\ start="\v<fun>(\(&)" end="\v<end>"
	\ contains=erlangFunArg,erlangGuard,erlangLambdaFunBody contained

syn region erlangLambdaFunBody
	\ start="\v\-\>" end="\v\;$" end="\v<end>&"
	\ contains=@erlangExpr,erlangClauseBegin contained

syn cluster erlangExpr add=erlangLambdaFun

" Erlang Expr
syn cluster erlangExpr add=@erlangSimpleExpr

" Colors
" Comments color
hi link erlangEdocComment     Comment
hi link erlangComment         Comment
hi link erlangInComment       Comment
hi link erlangTodo            Todo
hi link erlangEdocTag         Comment
hi link erlangEdocUnknownTag  Error

" Attribute
hi link erlangAttribute       Keyword

" Macros
hi link erlangPPAttribute   Macro
hi link erlangMacro         Macro
hi link erlangMacroString   Macro

" Include

" Erlang Constant
hi link erlangAtom          Constant
hi link erlangNumber        Number
hi link erlangString        String
hi link erlangChar          Character
hi link erlangSpecialChar   SpecialChar

" Delimiter
hi link erlangClauseBegin    Statement
hi link erlangSpecDelimiter  Statement
hi link erlangListDel        Statement
hi link erlangComprehensions Statement
hi link erlangRecordDel      Statement

" Operator
hi link erlangOperator      Operator

" Erlang Type
hi link erlangType          Type

" Identifier
hi link erlangIdentifier    Identifier

" FunctionName
hi link erlangBIF           Function
hi link erlangFunHead       Function
hi link erlangFunKeyword    Keyword

" Guard
hi link erlangGuardBIF      Conditional
hi link erlangGuard         Conditional

" Block
hi link erlangBlock         Statement
hi link erlangCase          Label
hi link erlangReceive       Label
hi link erlangAfter         Label
hi link erlangIf            Conditional

" Error
hi link erlangError         Error

" Syntax sync
syntax sync match FunctionStart grouphere erlangFun "\(^\w\)@="

let b:current_syntax = "erlang"
