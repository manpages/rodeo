%%
%% Setting uid, ulang and other uglyhacks
%%

-module(saloon_init).

-export([prepare/1]).

-define(DEV_MODE, true).

-include_lib("eunit/include/eunit.hrl").

prepare(Req) ->
	?debugFmt("~n~n~n~n=~p REQUEST===~nPath: ~p~nPeer: ~p~nBody query string data:~p~n", [X || {X, _} <- [cowboy_http_req:method(Req), cowboy_http_req:raw_path(Req), cowboy_http_req:peer(Req), cowboy_http_req:body_qs(Req)]]),
	case ?DEV_MODE of
		true -> 
			case make:all([load]) of
				up_to_date ->
					ok;
				error ->
					erlang:error(recompile_error)
			end; %dirty-dirty
		_ -> ok
	end,
	UID = case saloon_util:ck(<<"auth">>, Req) of 
		undefined -> 0;
		Cookie -> case saloon_auth:from_cookie(Cookie) of
			UID2 when is_integer(UID2) -> UID2;
			_ -> 0
		end
	end,
	
	Lang = case saloon_util:ck(<<"lang">>, Req) of
		<<"lv">> -> lv;
		<<"ru">> -> ru;
		%% ...
		_        -> en
	end,

	put(user, UID),      %% need to force
	put(language, Lang), %% changes here.
	?debugFmt("uid -> ~p; lang -> ~p~n", [UID, Lang]),
	ok.
