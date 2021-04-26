:- module(ldjam_api, [
              create_game/1,
	      next_card/2
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

% only test, can be deleted later
increase(N, N2) :-
		N2 is N + 1.

next_card('random_!_root', C) :-
	!,
	setof( Name, root_card_name(Name), Roots),
	random_member(Name, Roots),
	name_card(Name, C).
next_card(Name, Card) :-
	name_card(Name, Card).

root_card_name(Name) :-
	ldjam_twine:card(C),
	atom_concat(_, '_!_root', C.name),
	Name = C.name .
