-module(file_data).
-export([get_contents/0, parse/1]).

get_contents() -> 
    {ok, Contents} = file:read_file("stock_data.txt"),   
    Contents.

parse(Binary) -> jsx:decode(Binary, [{labels, atom}]).


