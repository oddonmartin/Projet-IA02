/* Affichage et initialisation du plateau */

depart(X):-plateau_test(X), affiche_plateau(X).

plateau_depart(X):- X =[[(0,0),(0,0),(0,0),(0,0),(0,0)],[(0,0),(0,0),(0,0),(0,0),(0,0)],
[32,33,34],e].

plateau_test(X):- X =[[(11,n),(32,s),(0,0),(0,0),(0,0)],[(45,e),(34,s),(0,0),(0,0),(0,0)],
[12,33,55],e].

affiche_plateau(X) :- ligne(1,X).

ligne(0,X):-ligne(1,X).
ligne(I,X):- I<6,!, colonnes(1,X), nl, I_Affichage is 6-I, write(I_Affichage), colonnes2(1,I,X),nl, New_i is I+1, ligne(New_i,X).
ligne(6,X):-colonnes(1,X),nl,chiffres(1).
ligne(I,X):-I>5.

chiffres(I):- I<6, !, write('   '), write(I), write(''), New_I is I+1, chiffres(New_I).
chiffres(I):- nl.
colonnes(1,X):- !, write('  ____'), colonnes(2,X).
colonnes(J,X):- J<6,!, write('____'), New_J is J+1, colonnes(New_J,X).
colonnes(J,X):- J>5.

colonnes2(J,I,X):- J<6,!, write('|'), K is 6-I, afficher_pion(K,J,X), New_J is J+1, colonnes2(New_J,I,X).
colonnes2(6,I,X):-write('|'),!.
colonnes2(J,I,X):- J>5.

afficher_pion(I,J,[E,R,M,Joueur]):-Case is I*10+J, memberchk((Case,D),E),!, write(' e'), affiche_orientation(D).
afficher_pion(I,J,[E,R,M,Joueur]):-Case is I*10+J, memberchk((Case,D),R),!, write(' r'), affiche_orientation(D).
afficher_pion(I,J,[E,R,M,Joueur]):-Case is I*10+J, memberchk(Case,M),!, write(' m ').
afficher_pion(I,J,[E,R,M,Joueur]):-write('   ').

affiche_orientation(D):- D='n',!,write('^').
affiche_orientation(D):-D='s',!,write('v').
affiche_orientation(D):-D='e',!,write('>').
affiche_orientation(D):-D='o',write('<').



/* Jeu */
/* On défini un coup comme une liste contenant la postition initiale et celle d'arrivée'. Ex : [(11,n),(12,e)] */

/* Dans le cas où la case destination n'est pas déjà occupée, on utilise coup_possible */
coup_possible([E,R,M,Joueur], [(Depart, _), (Arrivee, _)]):- memberchk((Arrivee,_),E), !, write('elephant en travers'), fail.
coup_possible([E,R,M,Joueur], [(Depart, _), (Arrivee, _)]):- memberchk((Arrivee,_),R), !, write('rhinoceros en travers'),fail.
coup_possible([E,R,M,Joueur], [(Depart, _), (Arrivee, _)]):- memberchk((Arrivee),M), !, write('montagne en travers'), fail.
coup_possible([E,R,M,e], [(Depart, _), (Arrivee, _)]):- \+memberchk((Depart,_),E), !, write('aucun elephant au depart de cette case'), fail.
coup_possible([E,R,M,r], [(Depart, _), (Arrivee, _)]):- \+memberchk((Depart,_),R), !, write('aucun rhinoceros au depart de cette case'),fail.

coup_possible(Plateau, [(Depart, _), (Arrivee, _)]):-  Arrivee is Depart+1, !.
coup_possible(Plateau, [(Depart, _), (Arrivee, _)]):-  Arrivee is Depart-1, !.
coup_possible(Plateau, [(Depart, _), (Arrivee, _)]):-  Arrivee is Depart+10, !.
coup_possible(Plateau, [(Depart, _), (Arrivee, _)]):-  Arrivee is Depart-10, !.

test(X):- plateau_test(X), coup_possible(X, [(45,e),(35,e)]).

poussee_possible(Plateau, Case, Direction).



