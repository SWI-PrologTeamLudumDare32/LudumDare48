:- module(ldjam_twine, [
              start_card/1,
              name_card/2,
              random_root_card/1
          ]).

:- use_module(library(http/html_write)).

:- dynamic start_card/1, card/1.

%!  start_card(-Name:atom) is det
%
%   multifile predicate that gives a starting card
%

start_card(start).

:- table name_card/2.

name_card(Name, Card) :-
    card(Card),
    card{name: Name} :< Card.

random_root_card(Card) :-
	debug(next_card, 'next_card(random_!_root)', []),
	setof( Name, root_card_name(Name), Roots),
	random_member(Name, Roots),
	name_card(Name, Card).


root_card_name(Name) :-
	ldjam_twine:card(C),
	atom_concat(_, '_!_root', C.name),
	Name = C.name .



:- multifile sandbox:safe_primitive/1.

sandbox:safe_primitive(ldjam_twine:name_card(_, _)).
sandbox:safe_primitive(ldjam_twine:random_root_card(_)).


:- use_module(ifml).


		 /*******************************
		 *     GraphML generation
		 *******************************/
:- use_module(library(ugraphs)).

% :- pack_install(graphml).
:- if(false).
:-use_module(library(graphml_ugraph)).

write_cards_graphml :-
    setof(Edge, edge(Edge), E),
    vertices_edges_to_ugraph([], E, UG),
    vertices(UG, V),
    setup_call_cleanup(
        open('map.graphml', write, S),
        graphml_write_ugraph(S, makename, V, UG),
        close(S)
        ).


edge(Me-Thee) :-
    ldjam_twine:card(C),
    Me = C.name,
    member(B, C.buttons),
    Thee = B.go,
    Thee \= '' .

makename(_, node(Node), Node).
makename(_, edge(From, To), N) :-
    format(atom(N), '~w -> ~w', [From, To]).
:- endif.













