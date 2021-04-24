:- module(server, [go/0]).
/** <module> Server end for LDjam
 *
 * Architecture - each page load starts a session
 * so there's no true 'sessions' (I'm not loading
  * the sessions lib). Page load starts a persistent pengine
  * and we use CHR
  */

:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/html_head)).
:- use_module(library(http/http_files)).

		 /*******************************
		 *  Pengine application setup
		 *******************************/


:- use_module(library(pengines)).

:- pengine_application(ldjam_pengine_app).
:- use_module(ldjam_pengine_app:ldjam_api).


go :- server(8888).

%!  server(+Port)
%
%   Start the server at http://localhost:Port

server(Port) :-
    http_server(http_dispatch,
                [ port(Port)
                ]).


		 /*******************************
		 *   Static file serving
		 *******************************/
:- multifile http:location/3.

http:location(js, '/js', []).
http:location(css, '/css', []).
http:location(img, '/img', []).
http:location(audio, '/audio', []).
user:file_search_path(css, './css').
user:file_search_path(js, './js').
user:file_search_path(icons, './icons').
user:file_search_path(audio, './Sound').

:- html_resource(style, [virtual(true), requires([css('style.css')]), mime_type(text/css)]).
:- html_resource(script, [virtual(true), requires([js('interact.js')]), mime_type(text/javascript)]).
:- html_resource(jquery, [virtual(true), requires([js('jquery.js')]), mime_type(text/javascript)]).
:- html_resource(pengines_script, [virtual(true), requires([root('pengine/pengines.js')]), mime_type(text/javascript)]).

:- http_handler(js(.), http_reply_from_files('js/', []),
           [priority(1000), prefix]).
:- http_handler(css(.), http_reply_from_files('css/', []),
                [priority(1000), prefix]).
:- http_handler(img(.), http_reply_from_files('icons/', []),
                [priority(1000), prefix]).
:- http_handler(audio(.), http_reply_from_files('Sound/', []),
                [priority(1000), prefix]).

:- http_handler(/, http_reply_file('./html/index.html', []), []).
:- http_handler('/index.html', http_reply_file('./html/index.html', []), []).









