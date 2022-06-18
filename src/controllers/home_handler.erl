-module(home_handler).
-behaviour(cowboy_handler).
-export([init/2, terminate/3]).

init(Req, State) ->
    Stocks = jsx:encode(main:run()),
    Res = cowboy_req:reply(
            200,
            #{<<"content-type">> => <<"application/json">>},
            Stocks,
            Req
    ),
    {ok, Res, State}.

terminate(_Reason, _Req, _State) -> ok.

