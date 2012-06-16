-module(saloon_main).

-behaviour(cowboy_http_handler).

-export([init/3, handle/2, terminate/2]).

-include_lib("eunit/include/eunit.hrl").

init({_Any, http}, Req, []) ->
	?debugMsg("init"),
	{ok, Req, 0}.

handle(Req, State) ->
	?debugMsg("handle"),
	saloon_init:prepare(Req),
	{ok, Rep} = cowboy_http_req:reply(
		200, [], mustache:render(saloon_main_view, "view/index.mustache"), Req
	),
	%{ok , Rep} = cowboy_http_req:reply(200, [], "ok", Req),
	{ok, Rep, State+1}.

terminate(_R, _S) ->
	ok.
