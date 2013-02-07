-module(pingpong).
-export([start/0, ping/2, pong/0]).

ping(0, Pong_PID) ->
    Pong_PID ! finished,
    io:format("Ping finished~n", []);

ping(N, Pong_PID) ->
    Pong_PID ! {ping, self()},
    receive
        pong ->
            case N rem 2 of
                0 -> Pong_PID ! {grumble, "Sally"};
                1 -> noop
            end,
            %grumble(N, Pong_PID),
            io:format("Ping!~n", [])
    end,
    ping(N-1, Pong_PID).

pong() ->
    receive
        finished ->
            io:format("Pong finished~n", []);
        {grumble, Name} ->
            io:format("*** Grumble, grumble, ~p! ***~n", [Name]),
            pong();
        {ping, Ping_PID} ->
            io:format("Pong!~n", []),
            Ping_PID ! pong,
            pong()
    end.

start() ->
   Num_Hits = 10,
   Pong_PID = spawn(pingpong, pong, []),
   spawn(pingpong, ping, [Num_Hits, Pong_PID]).
