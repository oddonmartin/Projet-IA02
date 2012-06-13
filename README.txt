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


------------------------------------------------------------
CE QUE J'AI REUSSI A FAIRE :
- Questions pour entrer la case, le sens du mouvement et la nouvelle orientation.
- Verification si c'est bien le pion du joueur et pas une montagne
- Vérification coup_possible, si oui on essaye pousse_possible (cf. commentaires coup_possible).
- Test si il reste des montagnes après un coup, sinon l'utilisateur qui joue a gagner et on fail
- Test si la case est bien un entier => plus robuste


ENCORE A FAIRE POUR LE JEU UTILISATEURS
------------------------------------------------------------
- Entrée sur le plateau : il faut entrer la case sur laquelle on veut aller
- Il faut mettre le pion à (0,0) dans poussee_possible quand il sort du plateau
- poussee_possible : on peut pousser les montagnes
- poussee_possible : quand tu as un animal qui pousse une montagne tout seul, il peut pousser la montagne sans être dans le bon sens... 

