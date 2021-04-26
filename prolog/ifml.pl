:- module(ifml, [
              load_ifml_to_cards/1,
              load_game_to_cards/2
          ]).

:- use_module(library(sgml)).
:- use_module(library(xpath)).
:- use_module(library(sgml_write)).
:- use_module(library(yall)).

:- debug(load_cards).

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

%
load_game_to_cards(StartDream, Dir) :-
    directory_files(Dir, Files),
    retractall(ldjam_twine:card(_)),
    retractall(ldjam_twine:start_card(_)),
    mangle_name(Start, StartDream, root),
    asserta(ldjam_twine:start_card(Start)),
    maplist({Dir}/[Name,Path]>>atom_concat(Dir, Name, Path), Files, Paths),
    maplist(load_dream_to_cards, Paths),
    report_invalid_buttons,
    !.

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
    xpath(DOM, //dream, Dream),
    xpath(Dream, /self(@name), DreamName),
    xpath(Dream, //card, Card),
    xpath(Card, /self(@name), Name),
    xpath(Card, show(1)/(*), Show),
    xml_str(Show, ShowStr),
    findall(Button, button(DreamName, Card, Button), Buttons),
    mangle_name(Mangle, DreamName, Name),
    \+ card_already_exists(Mangle),
    asserta(ldjam_twine:card(card{
                name: Mangle,
                show: ShowStr,
                buttons: Buttons
            })),
    false.
assert_cards(_).

card_already_exists(Mangle) :-
    ldjam_twine:card(OC),
     _{name: Mangle} :< OC,
     !.


button(DreamName, Card, button{
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
   find_go(DreamName, Button, Go),
   (   Go == '',
       RevealStr == ''
   ->
       xpath(Card,  /self(@name), N),
       format('Button ~w in dream ~w has no go, exit, or reveal~n', [N, DreamName])
   ;   true
   ).

find_go(_, Button, Go) :-
    xpath(Button, //exit(@dream), ExitDream),
    xpath(Button, //exit(@card), Card),
    mangle_name(Go, ExitDream, Card),
    !.
find_go(_, Button, Go) :-
    xpath(Button, //exit(@dream), ExitDream),
    mangle_name(Go, ExitDream, root),
    !.
find_go(DreamName, Button, Go) :-
   xpath(Button, go(@card), GoCard),
   mangle_name(Go, DreamName, GoCard),
   !.
find_go(_, _, '').

mangle_name(Mangle, Dream, Name) :-
    atom(Mangle),
    atom_codes(Mangle, MC),
    append(DC, `_!_`, Pre),
    append(Pre, NC, MC),
    atom_codes(Dream, DC),
    atom_codes(Name, NC),
    !.
mangle_name(Mangle, Dream, Name) :-
    atom_codes(Dream, DC),
    atom_codes(Name, NC),
    append([DC, `_!_`, NC], MC),
    atom_codes(Mangle, MC).

xml_str(XML, Str) :-
       with_output_to(string(Str), xml_write(current_output, XML, [header(false)])).

report_invalid_buttons :-
    ldjam_twine:card(C),
    member(Button, C.buttons),
    check_button(Button),
    fail.
report_invalid_buttons.

check_button(Button) :-
   \+ _{ go: _ } :< Button,
   !.
check_button(Button) :-
   _{ go: '' } :< Button,
   !.
check_button(Button) :-
    _{ go: Go } :< Button,
    ldjam_twine:card(OC),
    OC.name = Go,
    !.
check_button(Button) :-
    _{label: L, go: G} :< Button,
    format('Button ~w goes to ~w which doesn\'t exist~n', [L, G]),
    !.


