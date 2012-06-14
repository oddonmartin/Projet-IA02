/* Affichage et initialisation du plateau */

%siam.pl
:- include('init_affichage.pl').
:- include('moves.pl').
:- include('jeu_utilisateurs.pl').
:- include('ia.pl').
/*:- initialization(depart(X)).*/

depart(X):-plateau_test(X), affiche_plateau(X).

test5(P):- plateau_test(P), affiche_plateau(P), poussee_possible(P,33,e,1).
test6(P):- plateau_test(P), affiche_plateau(P), coup_possible(P,[31,e,e]).
test7([E,R,J,M], P2):- plateau_test([E,R,J,M]), remplacer_case(E, (11,n), (55,e), P2).
test8(X, P2):- plateau_test(X), Coup=[(55,n),o,n], jouer_coup(X, Coup, P2), affiche_plateau(X), affiche_plateau(P2).

test9(P, P2):- plateau_test(P), poussee_possible(P, [(44,o),o,o]), jouer_coup(P,[(44,o),n,o],P2),affiche_plateau(P2).

test10(P,P2):- plateau_test(P), poussee_possible(P, [(32,e),e,o]), jouer_coup(P,[(35,n),n,o],P2),affiche_plateau(P),affiche_plateau(P2).

test_jeu(P):-plateau_gagne(P), jeu_utilisateur(P).

test_coup_possible(P):- plateau_test(P),affiche_plateau(P), coup_possible(P, [(11,n),e,o]).

test11([E,R,M,J]):-plateau_test([E,R,M,J]), reste_montagnes(M, J). 