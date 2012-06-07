Projet-IA02
===========


TP du 31/05
------------
Test du les types :
integer(X) : X est un entier
number(X)
var(X)
nonvar(X)

Poussée possible : (solution du prof)
 - force : init à 1, +1 animal même sens, -1 animal sens inverse, 0 montagne
 - masse : init à 0, +1 à chaque montagne
 - ssi sur toute la chaine, force>0 et force>=masse

demande_case(X):- repeat, write('Entrez une case'), read(X), est_une_case(X), !.

:- dynamic(plateau/1).
set_plateau(P):-retractall(plateau(_)), asserta(plateau(P)).
affiche_plateau_court:- set_plateau(X), affiche_plateau(X).



TP du 7/06
------------
Trouver tous les coups possibles : setof, findall, bagof
findall(X, (member(I,[1,2,3,4]), X is I*I, L)
=> yes L=[1,4,9,16].
setof(X, (member(I,[1,2,3,4]), X is I*I, L)
=> yes 
L=[1] ?
L=[4] ?
L=[9] ?
L=[16] ?