-module(home_handler).
-behaviour(cowboy_handler).
-export([init/2, terminate/3]).

init(Req, State) ->
    Stocks = stocks_server:get_stocks_ranking(),
    Body = jsx:encode(Stocks),
    Res = cowboy_req:reply(
            200,
            #{<<"content-type">> => <<"application/json">>},
            Body,
            Req
    ),
    {ok, Res, State}.

terminate(_Reason, _Req, _State) -> ok.

