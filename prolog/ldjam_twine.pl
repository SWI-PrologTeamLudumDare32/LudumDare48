:- module(ldjam_twine, [
              card/1,
              start_card/1

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
