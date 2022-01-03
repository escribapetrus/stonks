-module(main).
-import(stocks, [get_stocks/1, stock_ranking/1]).
-import(file_data, [get_contents/1, parse/1]).
-export([run/0]).

run() -> 
    Url = binary_to_list(get_contents("source_url.txt")),
    Stocks = get_stocks({web, Url}),
    stock_ranking(Stocks).
