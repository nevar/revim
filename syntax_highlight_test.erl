%% @author Slava Yurin <v.yurin@office.ngs.ru>
%% @doc Some test module
-module(syntax_highlight_test).
-module(syntax_highlight_test, [A, B, C]).

-include("some_file.hrl").
-include_lib("ololo/include/trololo.hrl").

-behavior(my_server).
-behaviour(my_server).

-export([]).
-export([test/1, test/2, test/4]).
-export([test, test / 4]).

-import(lists, [c/1]).

-author([a, "dsafdsa"]).

-vsn(Test).

-type test() :: term() | atom() | list().
% comment
-opaque test() :: term().

-export_type([test/0, test/0]).
-import_type([test_there, [type_here/3]]).

-spec test(BBB :: module(), Aaaa :: string(), Aaaa :: string()) -> string().

-spec nth(N, List) -> Elem when
      N :: pos_integer(),
      List :: [T, ...],
      Elem :: T,
      T :: term().

-record(test, { test1 = 0 :: integer(),
                %dsafdsafdam
                test2 :: [term()]}).

-define(IF(B,T,F), (case (B) of true->(T); false->(F) end)).

-undef(A).
-ifndef(A).
-ifdef(A).
-define(A, 1).
-endif.

one_clause(A, B) ->
	A + B.

two_clause(A) ->
	A;
two_clause(B) ->
	B.

guard(A) when size(A) > 10; is_list(A) ->
	fun1(),
	m:fun1(),

	Fun(),
	m:Fun(),
	M:fun1(),
	M:fun1(),

	fun fun1/0,
	fun m:fun1/0,
	fun m:Fun/0,
	fun M:fun1/0,
	fun M:fun1/0,

	fun(A) ->
		ok
	; (B) when size(B) > 5 ->
		ok
	end,

	spawn(module, fun1, Args),
	spawn_link(module, fun1, Args),

	ok.

list() ->
	[A, B, C],
	[A || V <- B, is_integer(V)].

binary() ->
	<< <<A>> || <<A>> <= <<"aslfdksaf">> >>.

string() ->
	"lololololo",
	"lololo\r\nlolol\t",
	$a,
	$\a,
	$\A,
	$\r,
	$\\,
	$\001.

number() ->
	1,
	16#123ABD,
	1.0e+1,
	1.0e1,
	1.0e-1,
	-1.e-1,
	-1.0e-1,
	-10e-1.

'ATOM'() ->
	atom1, module, export,
	atom2,
	atom3,
	'atom o_O',
	'("\(0_0)/")',
	'Atom'.

variable() ->
	Var,
	_Var,
	_var,
	Var@1.

operation() ->
	begin
		A + A - A / A * A band A bor A bxor A bsr A bsl A and A or A xor A,
		not A rem A div A,
		#abcd.dsaf#sdaf.dsaf,
		#test{}
	end.

case(A) ->
	case true
		of true when is_list(A); is_integer(A) ->
			true
		; false ->
			false
	end.

if(A) ->
	if A == 1 ->
		1
	; A == 2 ->
		2
	end.

receive() ->
	receive
		A when is_list(A), not_is_list(A) ->
			A
	after 100 ->
		not_ok
	end.

try_catch() ->
	catch A,
	try
		A when is_list(A) -> A
	catch
		exit:A ->
			A
	after
		ok
	end.

error() ->
	end,
	of,
	after,
	receive
		A -> A,
		; B -> C
	after 100 ->
		not_ok;
	end,
	[A, , , V],
	[{],
	{[}.
