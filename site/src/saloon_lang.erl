-module(saloon_lang).

-export([t/1]).

-define(SRCPATH, "site/src/").
-define(BINPATH, "site/ebin/").

-include_lib("eunit/include/eunit.hrl").
-include_lib("kernel/include/file.hrl").
-include("site/conf/languages.hrl").

%%spawnpoint

t([{x,<<":peka: %%spawnpoint :trf:">>}]) -> 
	case saloon_ctx:language() of 
		en -> <<":peka: %%spawnpoint :trf:">>;
		ru -> <<":peka: %%spawnpoint :trf:">>;
		lv -> <<":peka: %%spawnpoint :trf:">>;
		es -> <<":peka: %%spawnpoint :trf:">>;
		_ -> <<"*:peka: %%spawnpoint :trf:*">>
	end;

t([{x,<<":peka: %%spawnpoint :trf:">>}]) -> 
	case saloon_ctx:language() of 
		en -> <<":peka: %%spawnpoint :trf:">>;
		ru -> <<":peka: %%spawnpoint :trf:">>;
		lv -> <<":peka: %%spawnpoint :trf:">>;
		es -> <<":peka: %%spawnpoint :trf:">>;
		_ -> <<"*:peka: %%spawnpoint :trf:*">>
	end;

t([{x,<<":peka: %%spawnpoint :trf:">>}]) -> 
	case saloon_ctx:language() of 
		en -> <<":peka: %%spawnpoint :trf:">>;
		ru -> <<":peka: %%spawnpoint :trf:">>;
		lv -> <<":peka: %%spawnpoint :trf:">>;
		es -> <<":peka: %%spawnpoint :trf:">>;
		_ -> <<"*:peka: %%spawnpoint :trf:*">>
	end;

t([{x,<<":peka: %%spawnpoint :trf:">>}]) -> 
	case saloon_ctx:language() of 
		en -> <<":peka: %%spawnpoint :trf:">>;
		ru -> <<":peka: %%spawnpoint :trf:">>;
		lv -> <<":peka: %%spawnpoint :trf:">>;
		es -> <<":peka: %%spawnpoint :trf:">>;
		_ -> <<"*:peka: %%spawnpoint :trf:*">>
	end;

t([{x,<<":peka: %%spawnpoint :trf:">>}]) -> 
	case saloon_ctx:language() of 
		en -> <<":peka: %%spawnpoint :trf:">>;
		ru -> <<":peka: %%spawnpoint :trf:">>;
		lv -> <<":peka: %%spawnpoint :trf:">>;
		es -> <<":peka: %%spawnpoint :trf:">>;
		_ -> <<"*:peka: %%spawnpoint :trf:*">>
	end;

t([{x,<<":peka: %%spawnpoint :trf:">>}]) -> 
	case saloon_ctx:language() of 
		en -> <<":peka: %%spawnpoint :trf:">>;
		ru -> <<":peka: %%spawnpoint :trf:">>;
		lv -> <<":peka: %%spawnpoint :trf:">>;
		es -> <<":peka: %%spawnpoint :trf:">>;
		_ -> <<"*:peka: %%spawnpoint :trf:*">>
	end;

t([{x,<<"Правильные бинари, блеать">>}]) -> 
	case saloon_ctx:language() of 
		en -> <<"Правильные бинари, блеать">>;
		ru -> <<"Правильные бинари, блеать">>;
		lv -> <<"Правильные бинари, блеать">>;
		es -> <<"Правильные бинари, блеать">>;
		_ -> <<"*Правильные бинари, блеать*">>
	end;

t([{short_text,<<"Then check out coolness that's generated by saloon_lang">>}]) -> 
	case saloon_ctx:language() of 
		en -> <<"Then check out coolness that's generated by saloon_lang">>;
		ru -> <<"Then check out coolness that's generated by saloon_lang">>;
		lv -> <<"Then check out coolness that's generated by saloon_lang">>;
		es -> <<"Then check out coolness that's generated by saloon_lang">>;
		_ -> <<"*Then check out coolness that's generated by saloon_lang*">>
	end;

t([{short_text,<<"First put some languages in your /site/conf/languages.hrl">>}]) -> 
	case saloon_ctx:language() of 
		en -> <<"First put some languages in your /site/conf/languages.hrl">>;
		ru -> <<"First put some languages in your /site/conf/languages.hrl">>;
		lv -> <<"First put some languages in your /site/conf/languages.hrl">>;
		es -> <<"First put some languages in your /site/conf/languages.hrl">>;
		_ -> <<"*First put some languages in your /site/conf/languages.hrl*">>
	end;

t([{test,<<"Test">>}]) -> 
	case saloon_ctx:language() of 
		en -> <<"Test">>;
		ru -> <<"Test">>;
		lv -> <<"Test">>;
		es -> <<"Test">>;
		_ -> <<"*Test*">>
	end;

t([{Tag,X}]) -> 
	Fname = ?SRCPATH ++ saloon_util:to_list(?MODULE) ++ ".erl",
	{_, Myself} = file:read_file(Fname),
	NewFunText = io_lib:format("%%spawnpoint~n~nt([{~w,<<\"~ts\">>}]) -> ~n	case saloon_ctx:language() of ~n", [Tag,X]),
	NewFunText2= lists:foldl(fun (L, Acc) -> Acc ++ io_lib:format("		~ts -> <<\"~ts\">>;~n", [L, X]) end, "", languages()),
	NewFunText3= io_lib:format("		_ -> <<\"*~ts*\">>~n	end;", [X]),
	NewerSelf = re:replace(
		Myself, 
		<<"%%spawnpoint">>, 
		unicode:characters_to_binary(NewFunText ++ NewFunText2 ++ NewFunText3)
	),
	file:write_file("site/src/saloon_lang.erl", NewerSelf),
	compile:file(Fname, [verbose,report_errors,report_warnings,{outdir,?BINPATH}]),
	%os:cmd("erlc " ++ Fname ++ " -o " ++ ?BINPATH), %%TODO: change to compile:file!
	code:purge(saloon_lang),
	code:load_file(saloon_lang),
	[<<"¡">>, X, <<"!">>].
