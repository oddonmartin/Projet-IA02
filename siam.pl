/* Affichage et initialisation du plateau */

%siam.pl
:- include('init_affichage.pl').
:- include('moves2.pl').
:- include('ia.pl').
:- initialization(depart(X)).

depart(X):-plateau_test(X), affiche_plateau(X).

test5(P):- plateau_test(P), affiche_plateau(P), poussee_possible(P,11,n,1).