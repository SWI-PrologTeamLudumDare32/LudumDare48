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
swipl -s server.pl -g "ifml:load_ifml_to_cards('xml/testgame.xml'),go"
````

Substituting whatever xml file you want. `testgame.xml` is what I'm developing with.

This will run the server, you can look at it at (port 8888)[http://localhost:8888/].

I've only tested with firefox at the moment.

 
