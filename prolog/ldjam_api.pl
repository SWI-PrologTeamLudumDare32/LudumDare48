:- module(ldjam_api, [
              mymember/2
          ]).

%  typical call to the pengine app
%  pengine_rpc('http://localhost:8888/', mymember(X, [a,b,c]), [application(ldjam_pengine_app)]).
%

% trivial pred for testing hookup
mymember(M, L) :- member(M, L).

