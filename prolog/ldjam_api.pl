:- module(ldjam_api, [
              mymember/2,
              create_game/1,
              next_card/3, 
              increase/2
          ]).

%  pengine_rpc('http://localhost:8888/', mymember(X, [a,b,c]), [application(ldjam_pengine_app)]).
%
:- use_module(library(pengines)).
:- use_module(ldjam_twine).

% trivial pred for testing hookup
mymember(M, L) :- member(M, L).

% the start of the game - create the first card
create_game(Card) :-
	start_card(Name),
	name_card(Name, Card).

% dummy for processing the next card - for the moment hard wired
next_card(Card, Par, Card2) :-
	pengine_debug('PROLOG: received ~w Function ~w~n',[Card, Par]),
	next_card(Name),
	name_card(Name, Card2).

% only test, can be deleted later
increase(N, N2) :-
		N2 is N + 1.
