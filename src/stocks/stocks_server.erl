-module(stocks_server).
-behaviour(gen_server).
-export([start_link/0, get_stocks_ranking/0, update_stocks_ranking/0]).
-export([init/1, handle_call/3, handle_cast/2, terminate/2]).

%% INTERFACE
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

get_stocks_ranking() ->
    gen_server:call(?MODULE, get_stocks_ranking).

update_stocks_ranking() ->
    gen_server:cast(?MODULE, update_stocks_ranking).

%% CALLBACKS
init(State) ->
    timer:apply_after(1000, ?MODULE, update_stocks_ranking, []),
    {ok, State}.

handle_call(get_stocks_ranking, _From, State) ->
    {reply, State, State}.

handle_cast(update_stocks_ranking, _State) ->
    timer:apply_after(10000000, ?MODULE, update_stocks_ranking, []),
    Stocks = main:run(),
    {noreply, Stocks}.

terminate(_Reson, _State)  ->
    ok.
