-module(main).
-import(stocks, [get_stocks/1, stock_ranking/1]).
-import(file_data, [get_contents/1]).
-export([run/0, report/0]).

run() -> 
    {ok, Url} = application:get_env(stonks, stocks_source_url),
    Stocks = get_stocks({web, Url}),
    lists:map(fun stocks:parse/1, stock_ranking(Stocks)).

report() -> 
    Stocks = run(),
    {ok, File} = file:open("stock_report.csv", [write]),
    F = fun(X) -> 
        {stockdata,Ticker, Name, Price, Liquidity, Position} = X,
        io:format(File, "~s,~s,~p,~p,~p~n", [Ticker, Name, Price, Liquidity, Position])
    end,
    lists:foreach(F, Stocks),
    file:close(File).
