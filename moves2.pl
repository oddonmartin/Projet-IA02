case_vide2([E,R,M,_],Case):- \+memberchk((Case,_),E), \+memberchk((Case,_),R), \+memberchk(Case,M).

case_bord2(11). case_bord2(12). case_bord2(13). case_bord2(14). case_bord2(15). 
case_bord2(21). case_bord2(31). case_bord2(41). case_bord2(51). 
case_bord2(25). case_bord2(35). case_bord2(45). 
case_bord2(52). case_bord2(53). case_bord2(54). case_bord2(55). 

coup_possible2([E,R,M,_], [Depart, Sens, _]):- case_suivante2(Depart,Sens,I1), est_une_case(I1), \+animaux_check2((I1,_),[E,R,M,_]), \+memberchk(I1,M).

/*poussee_entree_possible2(P,I,Sens):- case_suivante2(I,Sens,I1), write(I1),write(' '),compteur2(P,I1,Sens,X1),write(X1), X is X1+1,poussee_possible2(P,I1,Sens,X).*/

poussee_possible2(P, [(I,_),Sens,_]):-poussee_possible2(P, I, Sens, 1).
poussee_possible2(P, I, O, _):- case_suivante2(I, O, I1), case_vide2(P, I1),!.
poussee_possible2(P, I, O, X1):-
	case_suivante2(I, O, I1),
	compteur2(P, I1, O, X),
	X2 is X1 + X,
	X2>0, poussee_possible2(P, I1, O, X2).

compteur2(P, I, O, 1):- animaux_check2((I,O),P), !.
compteur2(P, I, O, -1):- inverse_dir2(O, O1), animaux_check2((I,O1),P), !.
compteur2([_,_,M,_], I, _, -0.9):- memberchk(I,M), !.
compteur2(P, I, _, 0):- animaux_check2((I,_),P).

animaux_check2((I,O),[E,_,_,_]):- memberchk((I,O),E), !.
animaux_check2((I,O),[_,R,_,_]):- memberchk((I,O),R), !.

inverse_dir2(n,s).
inverse_dir2(s,n).
inverse_dir2(e,o).
inverse_dir2(o,e).

est_une_case2(I):- integer(I), I=<55, I>=11, X1 is I mod 10, X1=<5, X2 is I mod 10, X2>0.

case_nord2(I,J):- J is I+10.
case_sud2(I,J):- J is I-10.
case_est2(I,J):- J is I+1.
case_ouest2(I,J):- J is I-1.

case_suivante2(I,n,I1):- est_une_case2(I), case_nord2(I,I1), !.
case_suivante2(I,s,I1):- est_une_case2(I), case_sud2(I,I1), !.
case_suivante2(I,e,I1):- est_une_case2(I), case_est2(I,I1), !.
case_suivante2(I,o,I1):- est_une_case2(I), case_ouest2(I,I1), !.


trouver_orient([E,_,_,_],I,O):- memberchk((I,O),E).
trouver_orient([_,R,_,_],I,O):- memberchk((I,O),R).

/* jouer_coup */

/*entree sur le plateau*/
jouer_coup2([E,R,M,J],[entree,X,O],NewP):- 
memberchk(X,M),!,
jouer_coup2([E,R,M,J],[X,O],NewPtmp),
jouer_coup2(NewPtmp,[entree,X,O],NewP).

jouer_coup2(P,[entree,X,O],NewP):- 
animaux_check2((X,O1),P),!,
jouer_coup2(P,[(X,_),O,O1],NewPtmp),
jouer_coup2(NewPtmp,[entree,X,O],NewP).

jouer_coup2([E,R,M,e],[entree,X,O],NewP):- remplacer_case2(E,(0,0),(X,O),NewE),NewP=[NewE,R,M,e].
jouer_coup2([E,R,M,r],[entree,X,O],NewP):- remplacer_case2(R,(0,0),(X,O),NewR),NewP=[E,NewR,M,e].

/*sortie du plateau*/
jouer_coup2(P,[sortie,X],NewP):- remplacer2(P,(X,_),(0,0),NewP).

/*sur place*/
jouer_coup2(P,[surplace,X,O],NewP):- remplacer2(P,(X,_),(X,O),NewP).

/*deplacement, case suivante vide*/
jouer_coup2([E,R,M,J],[I,Sens],NewP):-
case_suivante2(I,Sens,I1), 
case_vide2([E,R,M,_],I1),!,
remplacer2([E,R,M,J],(I,_),(I1,_),NewP).

jouer_coup2([E,R,M,J],[(I,_),Sens,NewOrient],NewP):-
case_suivante2(I,Sens,I1), 
case_vide2([E,R,M,_],I1),!,
remplacer2([E,R,M,J],(I,_),(I1,NewOrient),NewP).

/*deplacement animal, case suivante non vide(animal)*/
jouer_coup2([E,R,M,J], [(I,_),Sens,NewOrient], NewP):-
case_suivante2(I,Sens,I1), 
trouver_orient([E,R,_,_],I1,O),!,
jouer_coup2([E,R,M,J],[(I1,_),Sens,O],NewPtmp),
remplacer2(NewPtmp,(I,_),(I1,NewOrient),NewP).

/*deplacement animal, case suivante non vide(montagne)*/
jouer_coup2([E,R,M,J], [(I,_),Sens,NewOrient], NewP):-
case_suivante2(I,Sens,I1),!, 
jouer_coup2([E,R,M,J],[I1,Sens],NewPtmp),
remplacer2(NewPtmp,(I,_),(I1,NewOrient),NewP).

/*deplacement montagne, case suivante non vide(animal)*/
jouer_coup2([E,R,M,J],[I,Sens],NewP):-
case_suivante2(I,Sens,I1), 
trouver_orient([E,R,_,_],I1,O),!,
jouer_coup2([E,R,M,J],[(I1,_),Sens,O],NewPtmp),
remplacer2(NewPtmp,(I,_),(I1,_),NewP).

/*deplacement montagne, case suivante non vide(montagne)*/
jouer_coup2([E,R,M,J],[I,Sens],NewP):-
case_suivante2(I,Sens,I1),!, 
jouer_coup2([E,R,M,J],[I1,Sens],NewPtmp),
remplacer2(NewPtmp,(I,_),(I1,_),NewP).


/*deplacement, case suivante hors-jeu*/
jouer_coup2(P,[I,_],NewP):-
jouer_coup2(P,[sortie,I],NewP).

jouer_coup2(P,[(I,_),_,_],NewP):-
jouer_coup2(P,[sortie,I],NewP).



remplacer2([E,R,M,J], Case, NewCase, [NewPlateau,R,M,J]):- memberchk(Case,E), remplacer_case2(E, Case, NewCase, NewPlateau),!.
remplacer2([E,R,M,J], Case, NewCase, [E, NewPlateau, M, J]):- memberchk(Case,R), remplacer_case2(R, Case, NewCase, NewPlateau),!.
remplacer2([E,R,M,J], (I1,_), (I2,_), [E, R, NewPlateau, J]):- memberchk(I1,M), remplacer_case2(M, I1, I2, NewPlateau).

remplacer_case2([], _, _, []).
remplacer_case2([I|Q], I, NewI, [NewI|Q]):-!.
remplacer_case2([T|Q], I, NewI, [T|Q2]):-remplacer_case2(Q, I, NewI, Q2).
