-module(area_server).
-export([start/0, area/2, loop/0]).

start() -> spawn(area_server, loop, []).

area(Pid, What) -> rpc(Pid, What).

rpc(Pid, Request) ->
  Pid ! {self(), Request},
  receive
    {Pid, Response} ->
      Response
  end.

loop() ->
  receive
    {From, {rectangle, Width, Height}} ->
      From ! {self(), Width * Height},
      loop();
    {From, {circle, R}} ->
      From ! {self(), 3.14159 * R * R},
      loop();
    {From, Other} ->
      From ! {self(), {error, Other}},
      loop()
  end.

%% Pid = area_server:start().
%% area_server:area(Pid, {rectangle, 10, 8}).
%% area_server:area(Pid, {circle, 4}).
%% area_server:area(Pid, "FAIL").

