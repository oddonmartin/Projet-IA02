/* Affichage et initialisation du plateau */

depart(X):-plateau_test(X), affiche_plateau(X).

plateau_depart(X):- X =[[(0,0),(0,0),(0,0),(0,0),(0,0)],[(0,0),(0,0),(0,0),(0,0),(0,0)],
[32,33,34],e].

plateau_test(X):- X =[[(11,n),(21,n),(31,e),(32,e),(0,0)],[(45,e),(34,o),(0,0),(0,0),(0,0)],
[12,33,35],e].

affiche_plateau(X) :- ligne(1,X).

ligne(0,X):-ligne(1,X).
ligne(I,X):- I<6,!, colonnes(1,X), nl, I_Affichage is 6-I, write(I_Affichage), colonnes2(1,I,X),nl, New_i is I+1, ligne(New_i,X).
ligne(6,X):-colonnes(1,X),nl,chiffres(1).
ligne(I,_):-I>5.

chiffres(I):- I<6, !, write('   '), write(I), write(''), New_I is I+1, chiffres(New_I).
chiffres(_):- nl.
colonnes(1,X):- !, write('  ____'), colonnes(2,X).
colonnes(J,X):- J<6,!, write('____'), New_J is J+1, colonnes(New_J,X).
colonnes(J,_):- J>5.

colonnes2(J,I,X):- J<6,!, write('|'), K is 6-I, afficher_pion(K,J,X), New_J is J+1, colonnes2(New_J,I,X).
colonnes2(6,_,_):-write('|'),!.
colonnes2(J,_,_):- J>5.

afficher_pion(I,J,[E,_,_,_]):-Case is I*10+J, memberchk((Case,D),E),!, write(' e'), affiche_orientation(D).
afficher_pion(I,J,[_,R,_,_]):-Case is I*10+J, memberchk((Case,D),R),!, write(' r'), affiche_orientation(D).
afficher_pion(I,J,[_,_,M,_]):-Case is I*10+J, memberchk(Case,M),!, write(' m ').
afficher_pion(_,_,[_,_,_,_]):-write('   ').

affiche_orientation(D):- D='n',!,write('^').
affiche_orientation(D):-D='s',!,write('v').
affiche_orientation(D):-D='e',!,write('>').
affiche_orientation(D):-D='o',write('<').



/* Jeu */
/* On défini un coup comme une liste contenant la postition initiale et celle d'arrivée'. Ex : [(11,n),(12,e)] */

/*Dans le cas ou on veut juste changer l'orientation d'un animal, le coup est possible*/
coup_possible([E,_,_,_],[(I,_),(I,_)]):-memberchk((I,_),E),!.
coup_possible([_,R,_,_],[(I,_),(I,_)]):-memberchk((I,_),R),!.

/* Dans le cas où la case destination n'est pas déjà occupée, on utilise coup_possible */
coup_possible([E,_,_,_], [(_, _), (Arrivee, _)]):- memberchk((Arrivee,_),E), !, write('elephant en travers'), fail.
coup_possible([_,R,_,_], [(_, _), (Arrivee, _)]):- memberchk((Arrivee,_),R), !, write('rhinoceros en travers'),fail.
coup_possible([_,_,M,_], [(_, _), (Arrivee, _)]):- memberchk((Arrivee),M), !, write('montagne en travers'), fail.
coup_possible([E,_,_,e], [(Depart, _), (_, _)]):- \+memberchk((Depart,_),E), !, write('aucun elephant au depart de cette case'), fail.
coup_possible([_,R,_,r], [(Depart, _), (_, _)]):- \+memberchk((Depart,_),R), !, write('aucun rhinoceros au depart de cette case'),fail.

coup_possible(_, [(Depart, _), (Arrivee, _)]):-  Arrivee is Depart+1, !.
coup_possible(_, [(Depart, _), (Arrivee, _)]):-  Arrivee is Depart-1, !.
coup_possible(_, [(Depart, _), (Arrivee, _)]):-  Arrivee is Depart+10, !.
coup_possible(_, [(Depart, _), (Arrivee, _)]):-  Arrivee is Depart-10, !.

test(X):- plateau_test(X), coup_possible(X, [(45,e),(45,s)]).


animaux_check((I,O),[E,_,_,_]):- memberchk((I,O),E).              /*animaux_check vérifie si la case est prise par un animal dans le jeu*/
animaux_check((I,O),[_,R,_,_]):- memberchk((I,O),R).

case_nord(I,J):- J is I+10.
case_sud(I,J):- J is I-10.
case_est(I,J):- J is I+1.
case_ouest(I,J):- J is I-1.

case_suivante(I,n,I1):- case_nord(I,I1).
case_suivante(I,s,I1):- case_sud(I,I1).
case_suivante(I,e,I1):- case_est(I,I1).
case_suivante(I,o,I1):- case_ouest(I,I1).


/*animaux_meme_sens détermine les animaux qui sont dans le meme sens, 
il s'arrete de compter quand il tombe sur une case vide, ou une case hors du jeu*/
animaux_meme_sens([E,R,M,_],I,_,0):- \+animaux_check((I,_),[E,R,_,_]), \+memberchk(I,M),!.
animaux_meme_sens(_,I,n,0):- I>55,!.
animaux_meme_sens(_,I,s,0):- I<11,!.
animaux_meme_sens(_,I,e,0):- X is I mod 10, X>5,!.
animaux_meme_sens(_,I,o,0):- 0 is I mod 10,!.

animaux_meme_sens([E,R,M,_],I,O,X1):- case_suivante(I,O,I1) , animaux_meme_sens([E,R,M,_],I1,O,X), animaux_check((I,O),[E,R,_,_]),!, X1 is X+1.
animaux_meme_sens([E,R,M,_],I,O,X):- case_suivante(I,O,I1), animaux_meme_sens([E,R,M,_],I1,O,X).


/*animaux_sens_inverse détermine les animaux en sens inverse, 
il s'arrete de compter quand il tombe sur une case vide ou une case hors du jeu*/
inverse_div(n,s).
inverse_div(s,n).
inverse_div(e,o).
inverse_div(o,e).

animaux_sens_inverse([E,R,M,_],I,_,0):- \+animaux_check((I,_),[E,R,_,_]),\+memberchk(I,M),!.
animaux_sens_inverse(_,I,n,0):- I>55,!.
animaux_sens_inverse(_,I,s,0):- I<11,!.
animaux_sens_inverse(_,I,e,0):- X is I mod 10, X>5,!.
animaux_sens_inverse(_,I,o,0):- X is I mod 10, X=0,!.

animaux_sens_inverse([E,R,M,_],I,O,X1):- case_suivante(I,O,I1), animaux_sens_inverse([E,R,M,_],I1,O,X), inverse_div(O,Oinv), animaux_check((I,Oinv),[E,R,_,_]),!, X1 is X+1.
animaux_sens_inverse([E,R,M,_],I,O,X):- case_suivante(I,O,I1), animaux_sens_inverse([E,R,M,_],I1,O,X).


/*compte le nombre de montagnes, s'arrete quand case vide*/
nb_montagnes([E,R,M,_],I,_,0):- \+animaux_check((I,_),[E,R,_,_]),\+memberchk(I,M),!.
nb_montagnes(_,I,n,0):- I>55,!.
nb_montagnes(_,I,s,0):- I<11,!.
nb_montagnes(_,I,e,0):- X is I mod 10, X>5,!.
nb_montagnes(_,I,o,0):- 0 is I mod 10,!.
nb_montagnes([E,R,M,_],I,O,X1):- case_suivante(I,O,I1), nb_montagnes([E,R,M,_],I1,O,X), memberchk(I,M),!, X1 is X+1. 
nb_montagnes([E,R,M,_],I,O,X):- case_suivante(I,O,I1), nb_montagnes([E,R,M,_],I1,O,X). 

test2(P,X):- plateau_test(P), animaux_meme_sens(P,31,e,X).
test3(P,X):- plateau_test(P), animaux_sens_inverse(P,31,e,X).
test4(P,X):- plateau_test(P), nb_montagnes(P,31,e,X).

poussee_possible(Plateau, I, O):- animaux_meme_sens(Plateau,I,O,X), write('X='),write(X), animaux_sens_inverse(Plateau,I,O,Y),write('Y='),write(Y), 
nb_montagnes(Plateau,I,O,Z), write('Z='), write(Z),Res is Y+Z,write(' Res='),write(Res), X>Res.

test5(P):- plateau_test(P),poussee_possible(P,31,e).

