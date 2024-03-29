%%%-------------------------------------------------------------------
%% @doc stockscreener public API
%% @end
%%%-------------------------------------------------------------------

-module(stockscreener_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    Dispatch = cowboy_router:compile([
      {'_', [{"/", home_handler, []}]}
    ]),
    {ok, _} = cowboy:start_clear(
        listener,
        [{port, 8080}],
        #{env => #{dispatch => Dispatch}}
    ),
    stockscreener_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
