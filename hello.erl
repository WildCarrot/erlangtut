-module(hello).
-export([fac/1, convert_len/1, convert_len_generic/1, say_hi/2, cond_hi/1, reverse/1, zipper/2]).

fac(1) ->
    1;
fac(N) ->
    N * fac(N - 1).

convert_len({cm, X}) ->
    {inch, X / 2.54};
convert_len({inch, X}) ->
    {cm, X * 2.54}.
convert_len_generic(Length) ->
    case Length of
        {cm, X} -> 
           convert_len({cm, X});
        {inch, X} ->
           convert_len({inch, X});
        {feet, X} ->
           {inch, X / 12}
    end.
%%convert_len({inch, X}) ->
%%    {feet, X / 12}.

say_hi(Name, Word) ->
    io:format("Hello ~w.  Your word is ~w.~n", [Name, Word]).

cond_hi(Value) when Value > 5 ->
    io:format("My, what a big value you have! ~w ~n", [Value]);
cond_hi(Value) ->
    io:format("Puny value! ~w ~n", [Value]).

reverse(L1) ->
    reverse(L1, []).

reverse([Head1 | Rest1], Lout) ->
    reverse(Rest1, [Head1 | Lout]);
reverse([], Lout) ->
    Lout.

zipper(L1, L2) ->
    zipper(L1, L2, []).

zipper([Head1 | Rest1], [Head2 | Rest2], Lout) ->
    %[Head1 | [Head2 | Lout]];
    zipper(Rest1, Rest2, Lout ++ [Head1 | [Head2]]);
zipper([], [Head1], Lout) ->
    [Lout | Head1];
zipper([], [], Lout) ->
    Lout.

    