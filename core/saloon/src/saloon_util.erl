-module(saloon_util).
-export([
	pk/2,
	ck/2,

	md5/1,

	to_int/1,
	to_list/1,
	to_binary/1,

	apply/2,

	unixtime/0,
	unixtime_float/0,
	msec/0,
	date_format/1,

	keyfind/2,
	keyfind/3,
	json_find/2,
	json_find/3,

	log/1
]).

pk(Key, Req) -> %% Get value for post key
	proplists:get_value(Key, element(1, cowboy_http_req:body_qs(Req)), undefined).
ck(Key, Req) -> %% Get value for cookie key
%	io:format("ck!~n~p~n", [cowboy_http_req:cookie(Key, Req)]),
%	proplists:get_value(Key, element(1, cowboy_http_req:cookie(Key, Req, [])), undefined),
	element(1, cowboy_http_req:cookie(Key, Req, {undefined})).

md5(Value) ->
	<<X:128/big-unsigned-integer>> = .erlang:md5(to_binary(Value)),
	.lists:flatten(.io_lib:format("~32.16.0b", [X])).

to_int(Value) when is_integer(Value) ->
	Value;
to_int(Value) when is_list(Value) ->
	list_to_integer(Value);
to_int(Value) when is_binary(Value) ->
	list_to_integer(binary_to_list(Value)).

to_list(Value) when is_list(Value) ->
	Value;
to_list(Value) when is_integer(Value) ->
	integer_to_list(Value);
to_list(Value) when is_binary(Value) ->
	binary_to_list(Value);
to_list(Value) ->
	io_lib:format("~p", [Value]).

to_binary(Value) when is_binary(Value) ->
	Value;
to_binary(Value) when is_list(Value) ->
	list_to_binary(Value);
to_binary(Value) when is_integer(Value) ->
	list_to_binary(integer_to_list(Value));
to_binary(Value) ->
	list_to_binary(.io_lib:format("~p", [Value])).

apply({Module, Function}, Args) ->
	erlang:apply(Module, Function, Args);
apply({Module, Function, Args2}, Args) ->
	erlang:apply(Module, Function, Args ++ Args2);
apply(Fun, Args) ->
	erlang:apply(Fun, Args).

unixtime() ->
	{Mega, Secs, _} = erlang:now(),
	Mega * 1000000 + Secs.

unixtime_float() ->
	{Mega, Secs, MSec} = erlang:now(),
	Mega * 1000000 + Secs + MSec / 1000000.

msec() ->
	{Mega, Secs, MSec} = erlang:now(),
	Mega * 1000000000 + Secs * 1000 + MSec div 1000.

date_format(Time) ->
	{{_Year,Month,Day}, {Hour,Minutes,_Seconds}} = calendar:now_to_universal_time({Time div 1000000000, Time rem 1000000000 div 1000, Time rem 1000}),
	lists:concat([Day, " ", saloon_lang:t({month, to, Month}), " ", Hour, ":", Minutes]).

keyfind(Key, List) ->
	{Key, Value} = lists:keyfind(Key, 1, List),
	Value.

keyfind(Key, List, Default) ->
	case lists:keyfind(Key, 1, List) of
		{Key, Value} ->
			Value;
		_ ->
			Default
	end.

json_find(Key, {struct, List}) ->
	keyfind(Key, List).

json_find(Key, {struct, List}, Default) ->
	keyfind(Key, List, Default).

log(Stuff) ->
	Out = [msec()|Stuff],
	F = string:copies("~p ", length(Out)) ++ "~n",
	io:format(F, Out).
