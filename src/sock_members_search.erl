-module(sock_members_search).

-behaviour(gen_server).

-export([start_link/0, search/1]).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
	 terminate/2, code_change/3]).

-define(SERVER, ?MODULE).

-record(state, {connection, client}).

start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

search(Request) ->
	gen_server:call(?SERVER, {search, Request}).

init([]) ->
    {ok, Connection, Client} = amqp:start_rpc_client("localhost", <<"members_search">>),
    {ok, #state{connection = Connection, client = Client}}.

terminate(_Reason, State) ->
    amqp:stop_rpc_client(State#state.connection, State#state.client).

handle_call({search, Request}, _From, State) ->
	Response = amqp_rpc_client:call(State#state.client, Request),
    {reply, erlang:binary_to_term(Response), State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

