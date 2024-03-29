-module(http_test).
-include_lib("eunit/include/eunit.hrl").
-include_lib("stdlib/include/assert.hrl").

get_test() ->
    Res = http:get("https://jsonplaceholder.typicode.com/users"),

    ?assert(is_list(Res)),
    ?assert(length(Res) > 1).

parse_test() -> 
    String = "{\n  \"id\": 1,\n  \"name\": \"Leanne Graham\",\n  \"username\": \"Bret\",\n  \"email\": \"Sincere@april.biz\",\n  \"address\": {\n    \"street\": \"Kulas Light\",\n    \"suite\": \"Apt. 556\",\n    \"city\": \"Gwenborough\",\n    \"zipcode\": \"92998-3874\",\n    \"geo\": {\n      \"lat\": \"-37.3159\",\n      \"lng\": \"81.1496\"\n    }\n  },\n  \"phone\": \"1-770-736-8031 x56442\",\n  \"website\": \"hildegard.org\",\n  \"company\": {\n    \"name\": \"Romaguera-Crona\",\n    \"catchPhrase\": \"Multi-layered client-server neural-net\",\n    \"bs\": \"harness real-time e-markets\"\n  }\n}",
    Res = http:parse(String),
    Name = maps:get(name, Res),

    ?assertEqual(Name, <<"Leanne Graham">>).
