:- module(ldjam_api, [
              mymember/2,
              create_game/1,
              increase/2
          ]).

:- use_module(library(pengines)).
:- use_module(library(sandbox)).

:- dynamic current_process/4, current_location/3.

:- multifile sandbox:safe_primitive/1.

%  typical call to the pengine app
%  pengine_rpc('http://localhost:8888/', mymember(X, [a,b,c]), [application(ldjam_pengine_app)]).
%

:- use_module(ldjam_twine).

% trivial pred for testing hookup

%%%%%%%%%%%%%%%%%%%%%%%%%%%% Server Code %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Code by Anne Ogborn from Ludum Dara44 Game

create_game(ResponseText) :-
	pengine_self(PengineID),
	current_process(PengineID, _, _, _),
	!,
	debug(ld(redundant), 'game already created', []).

create_game(ResponseText) :-
	pengine_self(PengineID),
	buildResponse(ResponseText),
	thread_at_exit(killGame(PengineID)).

sandbox:safe_primitive(ldjam_api:create_game(_)).

killGame(PengineID) :-
	current_process(PengineID, PID, _, _),
	process_kill(PID).


mymember(M, L) :- member(M, L).

buildResponse(ResponseText) :-
	ResponseText = 'Ready player one :)'.


increase(N, N2) :- 
		N2 is N + 1.

sandbox:safe_primitive(ldjam_api:increase(_,_)).