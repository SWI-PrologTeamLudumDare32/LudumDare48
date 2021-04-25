:- module(ldjam_twine, [
              start_card/1,
              name_card/2,
              next_card/1
          ]).

:- use_module(library(http/html_write)).

:- dynamic start_card/1, card/1.

%!  start_card(-Name:atom) is det
%
%   multifile predicate that gives a starting card
%
start_card(start).
% a dummy for the moment, has to be calculate the next card in future
next_card(next).


%!  card(-Card:dict) is nondet
%
%   succeeds iff Card is a dict with card info (tag is =card=)
%
%   $ name
%   : atom name to refer to this card
%   $ html
%   : html to emit for this card, as termerized html
%   $ buttons
%   : list of Label=CardName for navigating

card(card{
         name: start,
         show: p('this is the start card'),
         buttons: ['Start'=start]
     }).

% only for test, a simple dummy for the next card, so nothing
card(card{
         name: next,
         show: p('this is the next card'),
         buttons: ['Next'=start]
     }).

:- table name_card/2.

name_card(Name, Card) :-
    card(RawCard),
    card{name: Name} :< RawCard,
    phrase(html(RawCard.show), Tokens),
    with_output_to(string(S), print_html(Tokens)),
    Card = RawCard.put(_{show: S}).

:- multifile sandbox:safe_primitive/1.

sandbox:safe_primitive(ldjam_twine:name_card(_, _)).

:- use_module(ifml).


