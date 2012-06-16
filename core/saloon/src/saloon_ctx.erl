-module(saloon_ctx).

%% connection level context functions
-export([
		user/0, user/1, 
		language/0, language/1,
		errors/0, errors/1, errors_push/1,
		successes/0, successes/1, successes_push/1,
		c_get/1, c_set/2,
		fill/0
	]).

%% session level context functions, not implemented
%% -export([
%%		s_get/1, s_set/2
%%	]).


-include_lib("eunit/include/eunit.hrl").


user() -> c_get(user).
user(UID) -> c_set(user, UID).

language() -> c_get(language).
language(Lang) -> c_set(language, Lang).

errors() -> c_get(errors).
errors(ErrorPropList) -> c_set(errors, ErrorPropList).
errors_push(Error) -> c_set(errors, [Error|c_get(errors)]).

successes() -> c_get(successes).
successes(SuccessesPropList) -> c_set(successes, SuccessesPropList).
successes_push(Success) -> c_set(successes, [Success|c_get(successes)]).

c_get(Key) -> 
	%?debugFmt("(~p) -> ~p", [Key, c_get_anyway(Key)]),
	case c_get_anyway(Key) of 
		undefined -> 
			?debugFmt("~n~n=== error ===~nContext key ~p not set.", [Key]),
			error(ctx_not_set);
		X -> X
	end.
c_set(Key, Value) -> 
	%?debugFmt("~p = ~p", [Key,Value]),
	case get(Key) of
		undefined -> put(Key, Value);
		_ -> 
			?debugFmt("~n~n=== error ===~nTrying to change context key ~p.", [Key]),
			error(ctx_change_forbidden)
	end.
c_get_anyway(Key) -> get(Key).

fill() ->
	lists:foreach(
		fun(X) -> case c_get_anyway(X) of 
					undefined -> c_set(X, []); 
					_ -> ok 
				end 
		end,
		[user, language, errors, successes]).
