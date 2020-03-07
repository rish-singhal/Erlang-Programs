% This is an attempt to understand erlang language, so enjoy :)
-module(helloworld). 
-export([start/0]). 
-export([loop/0]).

start() ->
  Pid = spawn(fun() -> loop() end),
  Pid ! {heyy, 10}.

loop() ->
  receive
   {heyy,Height} ->
    io:fwrite("~p",[Height]),
    loop()
  end.

