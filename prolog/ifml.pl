:- module(ifml, [
              load_ifml_to_cards/1
          ]).

:- use_module(library(sgml)).
:- use_module(library(xpath)).
:- use_module(library(sgml_write)).

load_ifml_to_cards(File) :-
    load_xml_file(File, DOM),
    (   xpath(DOM, //game(@start), StartCard)
    ->
       retractall(ldjam_twine:start_card(_)),
       asserta(ldjam_twine:start_card(StartCard))
    ;
       throw(error('Need a start  attribute in game'))
    ),
    retractall(ldjam_twine:card(_)),
    assert_cards(DOM).

assert_cards(DOM) :-
    xpath(DOM, //card, Card),
    xpath(Card, /self(@name), Name),
    xpath(Card, show(1)/(*), Show),
    xml_str(Show, ShowStr),
    findall(Button, button(Card, Button), Buttons),
    asserta(ldjam_twine:card(card{
                name: Name,
                show: ShowStr,
                buttons: Buttons
            })),
    false.
assert_cards(_).

button(Card, button{
                 label: LabelStr,
                 reveal: RevealStr,
                 go: Go
             }) :-
    xpath(Card, /button, Button),
    xpath(Button, label/(*), Label),
    xml_str(Label, LabelStr),
    (   xpath(Button, reveal, Reveal)
    ->
        xml_str(Reveal, RevealStr)
    ;
        RevealStr = ''
   ),
   (   xpath(Button, go(@card), Go)
   ->  true
   ;   Go = ''
   ).

xml_str(XML, Str) :-
       with_output_to(string(Str), xml_write(current_output, XML, [header(false)])).

