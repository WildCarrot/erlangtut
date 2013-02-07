-module(distpong).
-export([start_ping/1, start_pong/0, ping/2, pong/0]).

ping(0, Pong_Node) ->
    {pong, Pong_Node} ! finished,
    io:format("Ping finished~n", []);

ping(N, Pong_Node) ->
    {pong, Pong_Node} ! {ping, self()},
    receive
        pong ->
            case N rem 2 of
                0 -> {pong, Pong_Node} ! {grumble, "Sally"};
                1 -> noop
            end,
            io:format("Ping!~n", [])
    end,
    ping(N-1, Pong_Node).

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

start_pong() ->
    register(pong, spawn(distpong, pong, [])).

start_ping(Pong_Node) ->
    Num_Hits = 3,
    spawn(distpong, ping, [Num_Hits, Pong_Node]).
