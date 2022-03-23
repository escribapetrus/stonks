-module(cgi_controller).
% -behaviour(cowboy_handler).
-export([init/3, handle/2, terminate/2]).

init({tcp, http}, Req, _Opts) ->
    {ok, Req, undefined}.


handle(Req, State) ->
    {Path, Req1} = cowboy_req:path(Req),
    handle1(Path, Req1, State).

handle1(<<"/cgi">>, Req, State) ->
    {Args, Req1} = cowboy_req:qs_vals(Req),
    {ok, Bin, Req2} = cowboy_req:body(Req1),
    Val = mochijson2:decode(Bin),
    Res = call(Args, Val),
    Json = mochijson2:encode(Res),
    {ok, Req3} = cowboy_req:reply(200, [], Json, Req2),
    {ok, Req3, State};
handle1(Path, Req, State) ->
    Response = read_file(Path),
    {ok, Req1} = cowboy_req:reply(200, [], Response, Req),
    {ok, Req1, State}.

call([{<<"mod">>, MB}, {<<"func", FB>>}], X) -> 
    Mod = list_to_atom(binary_to_list(MB)),
    Func = list_to_atom(binary_to_list(FB)),
    apply(Mod, Func, [X]).

terminate(_Req, _State) -> ok.

read_file(Path) ->
    File = ["." | binary_to_list(Path)],
    case file:read_file(File) of
        {ok, Bin} -> Bin;
        _ -> ["<pre>cannot read:", File, "</pre>"]
    end.
