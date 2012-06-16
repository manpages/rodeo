-module(saloon_app).

-behaviour(application).

%% Application callbacks
-export([start/0, start/2, stop/1]).


%%
%% Getting dispatcher configuration
%%

-include("../../site/conf/dispatch.hrl").


%%
%% Application callbacks
%%

start() ->
	io:format("here ne ne slishal~n"),
	application:start(crypto),
	application:start(public_key),
	application:start(ssl),
	application:start(fission),
	application:start(cowboy),
	cowboy:start_listener(saloon_listener, 200,
		cowboy_tcp_transport, [{port, 53333}],
		cowboy_http_protocol, [{dispatch, dispatch()}]
	).

start(_T, _A) ->
	io:format("ne ne slishal~n"),
	cowboy:start_listener(saloon_listener, 200,
		cowboy_tcp_transport, [{port, 53333}],
		cowboy_http_protocol, [{dispatch, dispatch()}]
	).

stop(_S) ->
	ok.
