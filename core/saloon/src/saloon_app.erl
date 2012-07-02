-module(saloon_app).

-behaviour(application).

%% Application callbacks
-export([start/0, start/2, stop/1]).

%%
%% Application callbacks
%%

start() ->
	application:start(crypto),
	application:start(public_key),
	application:start(ssl),
	application:start(fission),
	application:start(cowboy),
	cowboy:start_listener(saloon_listener, 200,
		cowboy_tcp_transport, [{port, saloon_conf:port()}],
		cowboy_http_protocol, [{dispatch, saloon_conf:dispatch()}]
	).

start(_T, _A) ->
	io:format("herpderp"),
	cowboy:start_listener(saloon_listener, 200,
		cowboy_tcp_transport, [{port, saloon_conf:port()}],
		cowboy_http_protocol, [{dispatch, saloon_conf:dispatch()}]
	).

stop(_S) ->
	ok.
