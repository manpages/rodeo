-module(saloon_lang).

-export([t/1]).

-define(SRCPATH, "site/src/").
-define(BINPATH, "site/ebin/").

-include_lib("eunit/include/eunit.hrl").
-include_lib("kernel/include/file.hrl").
-include("site/conf/languages.hrl").

%%spawnpoint

t([{_,X}]) -> 
	%?debugFmt("Falling back to translation generator. String: <<\"~ts\">>", [X]),
	Fname = ?SRCPATH ++ saloon_util:to_list(?MODULE) ++ ".erl",
	?debugFmt("Filename: ~ts", [Fname]),
	{_, Myself} = file:read_file(Fname),
	NewFunText = io_lib:format("&~n~nt([{_,<<\"~ts\">>}]) -> ~n	case saloon_ctx:language() of ~n", [X]),
	NewFunText2= lists:foldl(fun (L, Acc) -> Acc ++ io_lib:format("		~ts -> <<\"~ts\">>;~n", [L, X]) end, "", languages()),
	NewFunText3= io_lib:format("		_ -> <<\"*~ts*\">>~n	end;", [X]),
	NewerSelf = re:replace(
		Myself, 
		<<"%%spawnpoint">>, 
		unicode:characters_to_binary(NewFunText ++ NewFunText2 ++ NewFunText3)
	),
	file:write_file("site/src/saloon_lang.erl", NewerSelf),
	?debugFmt("I'm compiling myself: ~p",[compile:file(Fname, [verbose,report_errors,report_warnings,{outdir,?BINPATH}])]),
	%os:cmd("erlc " ++ Fname ++ " -o " ++ ?BINPATH), %%TODO: change to compile:file!
	code:purge(saloon_lang),
	code:load_file(saloon_lang),
	[<<"¡">>, X, <<"!">>].
