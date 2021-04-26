# Ludum Dare 48
## Team SWI-Prolog

This is the **Team SWI-Prolog** entry for **Ludum Dare 48 Jam**.

## Acknowledgements

Walrus video from Discord.

LD Jam image 

## Team members

 * Anne Ogborn - programming
 
 
 ## Running the server
 
 You will need SWI-Prolog installed. Get the (latest development release)[https://www.swi-prolog.org/download/devel]
 and run here. I'm developing on 8.3.22
 
 To run the server (assuming OVERWORLDINTRODREAM is the first dream):
 
 On linux and mac
 
````
 cd prolog/
swipl -s server.pl -g "ifml:load_game_to_cards('OVERWORLDINTRODREAM', '../toolkits/md2xml/'),go"
````

`root` is the card the player sees when they first load the game.

On windows:

Double click the server.pl file.
A window will open and say something about welcome to prolog.
You'll be left with a prompt like `?-`.

At that prompt type
 
````
ifml:load_game_to_cards('OVERWORLDINTRODREAM', '../toolkits/md2xml/'),go.
````

Notice the period at the end. (and yes, type enter at the end of all of it)
There will be a moment's delay and if all goes well it will say

````
% Started server at http://localhost:8888/
````

On either system, 
this will run the server, you can look at it at (port 8888)[http://localhost:8888/].

I've only tested with firefox at the moment.


## Adding stuff to your md file

You can add audio/video to your reveal section. Recently most browsers stopped allowing media to play on load.
Not sure what's up, the video is playing but audio is not.

Video

````
<video width="320" height="240" autoplay="true"><source src="/img/walrus.mp4" type="video/mp4" />8c( no video</video>
````

````
<audio><source src="/audio/Dream-transition1.mp3"  autoplay="true"/></audio>
````

## Converting files

It's a game jam - things go sideways

The files are marked up in markdown, then run through a python program to make xml, and the prolog reads xml

````
cd  ~/ludumdare48/toolkits/md2xml/src
python -m main ..
````



 
