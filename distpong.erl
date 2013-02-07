% Start one node as "erl -sname one".
% Start second node as "erl -sname two".
%
% On two, compile and do distpong:start_pong().
% On one, compile and do distpong:start_ping(two@xxx).
% where xxx is the node name (like xubuntu12box or guardian).

-module(distpong).
-export([start_ping/1, start_pong/0, ping/2, pong/0]).

-record(spin,{name, age, word}).

ping(0, Pong_Node) ->
    {pong, Pong_Node} ! finished,
    io:format("Ping finished~n", []);

ping(N, Pong_Node) ->
    {pong, Pong_Node} ! {ping, self()},
    receive
        pong ->
            case N rem 3 of
                0 -> {pong, Pong_Node} ! {grumble, "Sally"};
		1 -> {pong, Pong_Node} ! #spin{name="Bob", age="37", word="Awesome!"};
		2 -> {pong, Pong_Node} ! #spin{name="June", word="Cool"}
%                1 -> noop
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
	#spin{name="Bob"} ->
	    io:format("Special Bob Spin ~p~n", [age]),
	    pong();
	{spin, Name, Age, Word} ->
	    io:format("SPINNING! ~p ~p ~p~n", [Name, Age, Word]),
	    pong();
        {ping, Ping_PID} ->
            io:format("Pong!~n", []),
            Ping_PID ! pong,
            pong()
% If don't receive any messages after 5 seconds, shutdown
%    after 5000 ->
%	    io:format("Pong timed out.")
    end.

start_pong() ->
    register(pong, spawn(distpong, pong, [])).

start_ping(Pong_Node) ->
    Num_Hits = 5,
    spawn(distpong, ping, [Num_Hits, Pong_Node]).
