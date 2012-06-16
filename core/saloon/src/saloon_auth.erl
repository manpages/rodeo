-module(saloon_auth).

%%
%% IMPORTANT! login/2, and login_by_id/2 
%% assume that passwords are already hashed.
%%

-export([
	login_by_id/2,
	login/2,
	add_user/2,
	from_cookie/1
]).

-include_lib("../include/user.hrl").

login(Email, Password) ->
	UIDVal = fission_syn:get({user, Email, id}),
	case (UIDVal) of
		{value, UID} -> login_by_id(UID, Password);
		false -> false
	end
.
	
login_by_id(UID, Password) -> 
	case (fission_syn:get_v({user, UID, password}) == Password) of
		true ->	cookie_value(UID, Password);
		false -> false
	end
.

add_user(Profile, {md5, Password}) ->
	Email = Profile#profile.email,
	ExistingID = fission_syn:get({user, Email, id}),
	case ExistingID of
		false ->
			UID = fission_syn:inc_v({user, nextid}),
			fission_list:push(users, UID),
			fission_syn:set({user, UID, lastseen}, 0),
			fission_syn:set({user, UID, profile}, Profile),
			fission_syn:set({user, UID, password}, Password),
			fission_syn:set({user, Email, id}, UID),
			
			login(Email, Password);
		_ -> false
	end;
add_user(Email, Password) ->
	add_user(Email, {md5, saloon_util:md5(Password)}).

cookie_value(UID, Password) ->
	random:seed(erlang:now()),
	Salt = integer_to_list(random:uniform(1000000)),
	Hash = saloon_util:md5(integer_to_list(UID) ++ "-w880i-" ++ Salt ++ "-" ++ Password),
	integer_to_list(UID) ++ "." ++ Salt ++ "." ++ Hash
.

from_cookie(Cookie) ->
	catch case string:tokens(saloon_util:to_list(Cookie), ".") of
		[SUID, Salt, Hash] ->
			UID = list_to_integer(SUID),
			Password = fission_syn:get_v({user, UID, password}),
			%io:format("~n~p~n~p~n~p~n~p~n~n", [SUID, Salt, Hash, saloon_util:md5(integer_to_list(UID) ++ "-w880i-" ++ Salt ++ "-" ++ Password)]),
			case saloon_util:md5(integer_to_list(UID) ++ "-w880i-" ++ Salt ++ "-" ++ Password) of
				Hash ->
					UID;
				_ ->
					false
			end;
		_ ->
			false
	end.
