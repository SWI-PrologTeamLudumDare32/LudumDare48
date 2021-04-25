:- module(ifml, [
              load_ifml_to_cards/1,
              load_game_to_cards/2
          ]).

:- use_module(library(sgml)).
:- use_module(library(xpath)).
:- use_module(library(sgml_write)).
:- use_module(library(yall)).

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

load_game_to_cards(Start, Dir) :-
    directory_files(Dir, Files),
    retractall(ldjam_twine:card(_)),
    retractall(ldjam_twine:start_card(_)),
    asserta(ldjam_twine:start_card(Start)),
    maplist([Name,Path]>>atom_concat('xml/', Name, Path), Files, Paths),
    maplist(load_dream_to_cards, Paths).

load_dream_to_cards(Path) :-
    atom_concat(_, '.xml', Path),
    debug(load_cards, 'loading ~w', [Path]),
    catch(
        (   load_xml_file(Path, DOM),
            assert_cards(DOM)),
        E,
        format('Cannot load ~w because ~w~n', [Path, E])
    ).
load_dream_to_cards(_).

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
    xpath(Card, button, Button),
    xpath(Button, label/(*), Label),
    xml_str(Label, LabelStr),
    (   xpath(Button, reveal/(*), Reveal)
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

