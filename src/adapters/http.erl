-module(http).
-export([get/1, parse/1]).

-spec get(string()) -> string().
get(Url) ->
    inets:start(),
    {ok, {{_Version, 200, _ReasonPhrase}, _Headers, Body}} = httpc:request(get, {Url, []}, [], []),
    Body.

-spec parse(string()) -> map().
parse(String) -> 
    X = list_to_binary(String),
    jsx:decode(X, [{labels, atom}]).
