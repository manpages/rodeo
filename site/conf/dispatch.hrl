dispatch() ->
	[
		{'_', [
				%%
				%% Site controllers
				%%

				{[<<"register">>, '...'], saloon_user, ["register"]},
				{[<<"login">>, '...'], saloon_user, ["login"]},
				{[<<"logout">>, '...'], saloon_user, ["logout"]},

				%%
				%% Default handlers
				%%

				{[<<"static">>, '...'], cowboy_http_static, 
					[
						{directory, <<"./static">>},
						{mimetypes, [
								{<<".txt">>, [<<"text/plain">>]},
								{<<".html">>, [<<"text/html">>]},
								{<<".htm">>, [<<"text/html">>]},
								{<<".css">>, [<<"text/css">>]},
								{<<".js">>, [<<"application/javascript">>]}
						]}
					]
				},
				{'_', saloon_main, []}
			]}
	].
