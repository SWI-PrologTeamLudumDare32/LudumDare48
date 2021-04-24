:- module(ldjam_twine, [
              start_card/1,
              name_card/2
          ]).

:- use_module(library(http/html_write)).


%!  start_card(-Name:atom) is det
%
%   multifile predicate that gives a starting card
%
start_card(start).


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
         html: p('this is the start card'),
         buttons: ['Start'=start]
     }).

:- table name_card/2.

name_card(Name, Card) :-
    card(RawCard),
    card{name: Name} :< RawCard,
    phrase(html(RawCard.html), Tokens),
    with_output_to(string(S), print_html(Tokens)),
    Card = RawCard.put(_{html: S}).

:- multifile sandbox:safe_primitive/1.

sandbox:safe_primitive(ldjam_twine:name_card(_, _)).

