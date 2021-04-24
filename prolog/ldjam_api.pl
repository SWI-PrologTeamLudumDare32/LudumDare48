:- module(ldjam_api, [
              mymember/2,
              create_game/1,
              increase/2
          ]).

%  pengine_rpc('http://localhost:8888/', mymember(X, [a,b,c]), [application(ldjam_pengine_app)]).
%

:- use_module(ldjam_twine).

% trivial pred for testing hookup
mymember(M, L) :- member(M, L).

create_game(Card) :-
	start_card(Name),
	name_card(Name, Card).

increase(N, N2) :-
		N2 is N + 1.
