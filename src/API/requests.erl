-module(requests).
-export([do_request/1, parse/1]).

-spec do_request(string()) -> string().
do_request(Url) -> 
    inets:start(),
    {ok, {{_Version, 200, _ReasonPhrase}, _Headers, Body}} = httpc:request(get, {Url, []}, [], []),
    Body.

-spec parse(string()) -> map().
parse(String) -> 
    X = list_to_binary(String),
    jsx:decode(X, [{labels, atom}]).