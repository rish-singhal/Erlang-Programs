-module(test).

-export([start/2]).

start(Inp, Out) ->
    io:fwrite("Input File: ~p.~n", [Inp]),
    io:fwrite("Output File: ~p.~n", [Out]),
    % parsing input and output files
    {ok, IFile} = file:open(Inp, [read]),
    {ok, OFile} = file:open(Out, [write]),
    {ok, Txt} = file:read(IFile, 1024 * 1024),
    io:fwrite(OFile, "Hii!! ~p.", [Txt]).
