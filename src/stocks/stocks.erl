-module(stocks).
-export([put_indexes/2, rank/2, get_stocks/0]).

% -import(requests, [parse/1, do_request/0]).
-import(file_data, [get_contents/0, parse/1]).

% -record(stockdata, {ticker, company_name, price, ev_ebit, roic, liabilities_assets}).

get_stocks() -> 
    % Response = parse(do_request()),
    Response = parse(get_contents()),
    Filtered = [X || 
        X <- Response, 
        maps:is_key(eV_Ebit, X),
        maps:is_key(roic, X),
        maps:is_key(margemEbit, X),
        maps:is_key(passivo_Ativo, X),
        maps:get(margemEbit, X) > 0,
        maps:get(passivo_Ativo, X) < 2
    ],
    Filtered.
    % EYRanked = ev_ebit_ranking(Filtered),
    % ROICRanked = roic_ranking(EYRanked),
    % ROICRanked.


-spec rank(atom(), list(map())) -> list(map()).
rank(eV_Ebit, Maps) -> 
    RankCriteria = fun(A, B) -> maps:get(eV_Ebit, A) > maps:get(eV_Ebit, B) end,
    Sorted = lists:sort(RankCriteria, Maps),
    put_indexes(Sorted, eV_EbitRanking);

rank(roic, Maps) -> 
    RankCriteria = fun(A, B) -> maps:get(roic, A) < maps:get(roic, B) end,
    Sorted = lists:sort(RankCriteria, Maps),
    put_indexes(Sorted, roicRanking).

-spec put_indexes(list(), string()) -> list().
put_indexes(Maps, IndexName) -> put_indexes(Maps, IndexName, 1, []).

-spec put_indexes(list(), atom(), integer(), list()) -> list().
put_indexes([], _, _, Res) -> Res;
put_indexes([H|T], IndexName, Index, Res) -> 
    Updated = maps:put(IndexName, Index, H), 
    put_indexes(T, IndexName, Index + 1, [Updated | Res]).