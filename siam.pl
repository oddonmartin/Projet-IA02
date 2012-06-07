/* Affichage et initialisation du plateau */

%siam.pl
:- include('init_affichage.pl').
:- include('moves.pl').
:- include('ia.pl').
:- initialization(depart(X)).

depart(X):-plateau_test(X), affiche_plateau(X).

test5(P):- plateau_test(P), affiche_plateau(P), poussee_possible(P,31,e,1).
test6(P):- plateau_test(P), affiche_plateau(P), coup_possible(P,[31,e,e]).
test7([E,R,J,M], P2):- plateau_test([E,R,J,M]), remplacer_case(E, (11,n), (55,e), P2).
test8(P, P2):- plateau_test(P), Coup=[(55,o),o,n], jouer_coup(P, Coup, P2).