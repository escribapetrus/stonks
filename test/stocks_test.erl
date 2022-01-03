-module(stocks_test).
-import(stocks, [put_indexes/2, rank/2, get_stocks/1, stock_ranking/1]).
-include_lib("eunit/include/eunit.hrl").
-include_lib("stdlib/include/assert.hrl").

stock_ranking_test() -> 
    Stocks = get_stocks({file, "stock_data.txt"}),
    Res = stock_ranking(Stocks),

    ?assert(is_list(Res)).

roic_ranking_test() ->
    Stocks = get_stocks({file, "stock_data.txt"}),
    Ranking = rank(roic, Stocks),

    ?assert(is_list(Ranking)),
    ?assert(lists:all(fun(X) -> maps:is_key(roicRank, X) end, Ranking)).

ev_ebit_test() -> 
    Stocks = get_stocks({file, "stock_data.txt"}),
    Ranking = rank(eV_Ebit, Stocks),

    ?assert(is_list(Ranking)),
    ?assert(lists:all(fun(X) -> maps:is_key(eV_EbitRank, X) end, Ranking)).

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
