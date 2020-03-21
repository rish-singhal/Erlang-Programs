-module(tt).

-export([start/0, loop/0]).

start() ->
	Pid = spawn(?MODULE, loop, []),
	Pid!{yay},
	Pid!{yay}.

loop() ->
  receive 
	  {yay} ->
		  io:format("frefrfgg~n")
 end.
