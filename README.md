# Ludum Dare 48
## Team SWI-Prolog

This is the **Team SWI-Prolog** entry for **Ludum Dare 48 Jam**.

## Team members

 * Anne Ogborn - programming
 
 
 ## Running the server
 
 You will need SWI-Prolog installed. Get the (latest development release)[https://www.swi-prolog.org/download/devel]
 and run here. I'm developing on 8.3.22
 
 To run the server:
 
 On linux and mac
 
````
 cd prolog/
swipl -s server.pl -g "ifml:load_game_to_cards(root, 'xml/'),go"
````

`root` is the card the player sees when they first load the game.

On windows:

Double click the server.pl file.
A window will open and say something about welcome to prolog.
You'll be left with a prompt like `?-`.

At that prompt type

````
ifml:load_game_to_cards(root, 'xml/'),go.
````

Notice the period at the end. (and yes, type enter at the end of all of it)
There will be a moment's delay and if all goes well it will say

````
% Started server at http://localhost:8888/
````

On either system, 
this will run the server, you can look at it at (port 8888)[http://localhost:8888/].

I've only tested with firefox at the moment.

 
