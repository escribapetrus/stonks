-module(file_data).
-export([get_contents/1, parse/1]).

get_contents(Filename) -> 
    {ok, Contents} = file:read_file(Filename),   
    Contents.

parse(Binary) -> jsx:decode(Binary, [{labels, atom}]).


