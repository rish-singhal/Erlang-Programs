-module(test).

-export([start/2, readlines/1, msort/2, splitlist/2, mergefun/2, mergefun/3, append/2, print/2]).

%function to parse values
readlines(FileName) ->
    	{ok, Data} = file:read_file(FileName),
    	StringData = string:lexemes(string:tokens(erlang:binary_to_list(Data), "\n") , " "),
    	[list_to_integer(Item) || Item <- StringData ].

%main function
start(Input, Output) ->
	Arr = readlines(Input),
	Pid = spawn(?MODULE, msort, [self(), Arr]),	
	receive
    		{ Pid, SArr } -> 
			    SArr
    	end,

% printing to file
       {ok, OFile} = file:open(Output, [write]),
       print(SArr, OFile).

%function to print element by element into file
print([],File) ->
       io:fwrite(File," \n", []);

print([H|T],File) ->
      io:fwrite(File, "~p ", [H]),
      print(T,File).

%main merge sort function
msort(Pid, Arr) ->
	if 
	        length(Arr) == 1 ->	
			Pid ! { self(), Arr };
		
		true ->	  	
		   {LeftArr, RightArr} = splitlist(Arr, length(Arr) div 2),
		   PidL = spawn(?MODULE, msort, [self(), LeftArr]),	
		   PidR = spawn(?MODULE, msort, [self(), RightArr]),
	   	   receive
			{ PidL, LSArr } ->
				LSArr
		   end,
   		   receive
			{ PidR, RSArr } ->
				RSArr
		   end,
   		   Pid ! { self(), mergefun(LSArr, RSArr) }
	end.

%to split list recursively
splitlist([H|L], S) ->
	if 
		S == 0 ->
		   {[], [H|L]};
	     	true ->	
		   { LArr, RArr } = splitlist(L,S-1),
	       	   { [H|LArr], RArr}
	end.

%append function
append([H|T], AppArr) ->
    [H|append(T, AppArr)];

append([], AppArr) ->
    AppArr.


% mergefunction implemented
mergefun(Arr1, Arr2) ->
	mergefun(Arr1, Arr2, []).

mergefun([], [], SArr) -> 
	SArr;

mergefun([], Arr2, SArr) ->
	append(SArr,Arr2);

mergefun(Arr1, [], SArr) ->
	append(SArr,Arr1);

mergefun([H1|Arr1], [H2|Arr2], SArr ) ->

	if 
		H1 > H2 ->
			mergefun([H1|Arr1], Arr2, append(SArr,[H2]));
		
		true ->
			mergefun(Arr1, [H2|Arr2], append(SArr,[H1]))
	end.
