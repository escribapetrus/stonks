-module(stocks).
-export([put_indexes/2, rank/2, get_stocks/0, stock_ranking/1]).
% -import(requests, [parse/1, do_request/0]).
-import(file_data, [get_contents/0, parse/1]).
-import(lists, [map/2, sort/2]).
-import(maps, [put/3, get/2, is_key/2]).

% -record(stockdata, {ticker, company_name, price, ev_ebit, roic, liabilities_assets}).

-spec stock_ranking(list()) -> list().
stock_ranking(Stocks) ->
    PutStockRank = fun(X) -> put(stockRank, get(eV_EbitRank, X) + get(roicRank, X), X) end,
    RankCriteria = fun(A, B) -> get(stockRank, A) > get(stockRank, B) end,
    StocksEYRanked = rank(eV_Ebit, Stocks),
    StocksROICRanked = rank(roic, StocksEYRanked),
    Ranked = map(PutStockRank, StocksROICRanked),
    sort(RankCriteria, Ranked).

-spec get_stocks() -> list().
get_stocks() -> 
    % Response = parse(do_request()),
    Response = parse(get_contents()),
    Filtered = [X || 
        X <- Response, 
        is_key(eV_Ebit, X),
        is_key(roic, X),
        is_key(margemEbit, X),
        is_key(passivo_Ativo, X),
        get(margemEbit, X) > 0,
        get(passivo_Ativo, X) < 2
    ],
    Filtered.

-spec rank(atom(), list(map())) -> list(map()).
rank(eV_Ebit, Maps) -> 
    RankCriteria = fun(A, B) -> get(eV_Ebit, A) > get(eV_Ebit, B) end,
    Sorted = sort(RankCriteria, Maps),
    put_indexes(Sorted, eV_EbitRank);

rank(roic, Maps) -> 
    RankCriteria = fun(A, B) -> get(roic, A) < get(roic, B) end,
    Sorted = sort(RankCriteria, Maps),
    put_indexes(Sorted, roicRank).

-spec put_indexes(list(), string()) -> list().
put_indexes(Maps, IndexName) -> put_indexes(Maps, IndexName, 1, []).

-spec put_indexes(list(), atom(), integer(), list()) -> list().
put_indexes([], _, _, Res) -> Res;
put_indexes([H|T], IndexName, Index, Res) -> 
    Updated = put(IndexName, Index, H), 
    put_indexes(T, IndexName, Index + 1, [Updated | Res]).