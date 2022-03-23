-module(home_handler).
-behaviour(cowboy_handler).
-export([init/2, terminate/3]).

init(Req, State) ->
    Res = cowboy_req:reply(
            200,
            #{<<"content-type">> => <<"text/plain">>},
            "Home Screen",
            Req
    ),
    {ok, Res, State}.

terminate(_Reason, _Req, _State) -> ok.

%% read_file(Path) ->
%%     File = ["." | binary_to_list(Path)],
%%     case file:read_file(File) of
%%         {ok, Bin} -> Bin;
%%         _ -> ["<pre>cannot read:", File, "</pre>"]
%%     end.
