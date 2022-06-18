-module(stocks).
-export( [put_indexes/2, rank/2, get_stocks/1, stock_ranking/1, parse/1]).

-record(stockdata, {ticker, name, price, liquidity, rank}).

-spec stock_ranking(list()) -> list().
stock_ranking(Stocks) ->
    PutStockRank = fun(X) -> maps:put(stockRank, maps:get(eV_EbitRank, X) + maps:get(roicRank, X), X) end,
    RankCriteria = fun(A, B) -> maps:get(stockRank, A) > maps:get(stockRank, B) end,
    StocksEYRanked = rank(eV_Ebit, Stocks),
    StocksROICRanked = rank(roic, StocksEYRanked),
    Ranked = lists:map(PutStockRank, StocksROICRanked),
    lists:sort(RankCriteria, Ranked).

-spec get_stocks({atom(), string()}) -> list().
get_stocks(Source) -> 
    Response = case Source of
        {file, Filename} -> file_data:parse(file_data:get_contents(Filename));
        {web, Url} -> http:parse(http:get(Url))
    end,

    [X || 
        X <- Response,
        maps:is_key(eV_Ebit, X),
        maps:is_key(roic, X),
        maps:is_key(margemEbit, X),
        maps:is_key(passivo_Ativo, X),
        maps:is_key(liquidezMediaDiaria, X),
        maps:get(margemEbit, X) > 0,
        maps:get(passivo_Ativo, X) < 2,
        maps:get(liquidezMediaDiaria, X) > 100000
    ].

-spec rank(atom(), list(map())) -> list(map()).
rank(eV_Ebit, Maps) -> 
    RankCriteria = fun(A, B) -> maps:get(eV_Ebit, A) > maps:get(eV_Ebit, B) end,
    Sorted = lists:sort(RankCriteria, Maps),
    put_indexes(Sorted, eV_EbitRank);

rank(roic, Maps) -> 
    RankCriteria = fun(A, B) -> maps:get(roic, A) < maps:get(roic, B) end,
    Sorted = lists:sort(RankCriteria, Maps),
    put_indexes(Sorted, roicRank).

-spec put_indexes(list(), atom()) -> list().
put_indexes(Maps, IndexName) -> put_indexes(Maps, IndexName, 1, []).

-spec put_indexes(list(), atom(), integer(), list()) -> list().
put_indexes([], _, _, Res) -> Res;
put_indexes([H|T], IndexName, Index, Res) -> 
    Updated = maps:put(IndexName, Index, H),
    put_indexes(T, IndexName, Index + 1, [Updated | Res]).
    
parse(Map) ->
    Ticker = binary_to_list(maps:get(ticker, Map)),
    CompanyName = binary_to_list(maps:get(companyName, Map)),
    Price = maps:get(price, Map),
    Liquidity = maps:get(liquidezMediaDiaria, Map),
    Rank = maps:get(stockRank, Map),
    #stockdata{ticker=Ticker, name=CompanyName, price=Price, liquidity=Liquidity, rank=Rank}.
