-module(stocks_test).
-import(stocks, [put_indexes/2, rank/2, get_stocks/0]).
-include_lib("eunit/include/eunit.hrl").
-include_lib("stdlib/include/assert.hrl").

roic_ranking_test() ->
    Stocks = get_stocks(),
    Rank = rank(roic, Stocks),
    Mapped = lists:map(fun(X) -> {maps:get(ticker, X), maps:get(roicRanking, X)} end, Rank),
    erlang:display(Mapped),

    ?assert(is_list(Mapped)),
    ?assert(true).

ev_ebit_test() -> 
    Stocks = get_stocks(),
    Rank = rank(eV_Ebit, Stocks),
    Mapped = lists:map(fun(X) -> {maps:get(ticker, X), maps:get(eV_EbitRanking, X)} end, Rank),
    erlang:display(Mapped),

    ?assert(is_list(Mapped)),
    ?assert(true).

put_indexes_test() ->
    MapList = [
        #{<<"Position">> => "First"},
        #{<<"Position">> => "Second"},
        #{<<"Position">> => "Third"},
        #{<<"Position">> => "Fourth"}
    ],
    Expected = [
        #{index => 4, <<"Position">> =>"Fourth"},
        #{index => 3, <<"Position">> =>"Third"},
        #{index => 2, <<"Position">> =>"Second"},
        #{index => 1, <<"Position">> =>"First"}],

    Res = put_indexes(MapList, index),

    ?assertEqual(length(Res), length(Expected)),
    ?assertEqual(Res, Expected).
