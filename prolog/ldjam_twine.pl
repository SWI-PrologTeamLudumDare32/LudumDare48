:- module(ldjam_twine, [
              start_card/1,
              name_card/2
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

:- multifile sandbox:safe_primitive/1.

sandbox:safe_primitive(ldjam_twine:name_card(_, _)).

:- use_module(ifml).

% :- load_ifml_to_cards('xml/testgame.xml').
