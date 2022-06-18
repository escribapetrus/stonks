stockscreener
=====

An OTP application

Build
-----

    $ rebar3 compile


To get the stocks information, paste the source url in a configuration file `config/sys.config`: 
```
[
 {stonks,
  [
   {stocks_source_url, "[SOURCE_URL]"}
  ] 
 }
].

```
