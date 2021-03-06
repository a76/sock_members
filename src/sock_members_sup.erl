-module(sock_members_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

%% Helper macro for declaring children of supervisor
-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).

%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([]) ->
    Children = [
        ?CHILD(sock_members_pub, worker),
        ?CHILD(sock_members_search, worker),
        ?CHILD(sock_members_handler, worker),
        ?CHILD(sock_members_sync_handler, worker)
    ],
	RestartStrategy = {one_for_one, 0, 1},
	{ok, {RestartStrategy, Children}}.

