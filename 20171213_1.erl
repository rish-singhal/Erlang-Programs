-module('20171213_1.erl').

-export([start/2, readlines/1, nodefun/2,  sendMessage/3]).

%function to parse values
readlines(FileName) ->
    	{ok, Data} = file:read_file(FileName),
    	StringData = string:lexemes(string:tokens(erlang:binary_to_list(Data), "\n") , " "),
    	[list_to_integer(Item) || Item <- StringData ].

%main function
start(Input, Output) ->
        {ok, OFile} = file:open(Output, [write]),
	[N, V]= readlines(Input),
	Processes = [spawn(?MODULE, nodefun, [X,OFile]) || X  <- lists:seq(0, N-1)],
	ProcessesArr = lists:zip(Processes, tl(Processes) ++ [hd(Processes)]),
	sendMessage(V, N, ProcessesArr).


sendMessage(V, N, [H|Arr]) ->
	{Pid1, _} = H,
	Pid1 ! {inmssg, V, N, [H|Arr], -1 },
	done.

nodefun(MyId, File) ->
	receive 
		{lastmssg, V, Id} ->
		      io:fwrite(File, "Process ~p recieved token ~p from process ~p.~n",[MyId, V, Id]);		
		{inmssg, V, Cnt,  RArr, Id} ->	
		     [H|Arr] = RArr,
		     {_,PidA} = H,
		     if 
		     Id /= -1 ->
			io:fwrite(File, "Process ~p recieved token ~p from process ~p.~n",[MyId, V, Id]),
				if
					length(Arr) == 0 ->
					  PidA ! {lastmssg, V, MyId};
					true ->
					  PidA ! {inmssg, V, Cnt - 1, Arr, MyId}
				end;
			   true ->
				PidA ! {inmssg, V, Cnt-1, Arr, MyId}
			end,
		nodefun(MyId, File)
	end.
