% coup=[11,n,o]
/* Vérifie si le joueur veut jouer un de ses pions ou en faire entrer un => a finir parce que ça marche pas avec l'entrée */
coup_possible([E,R,M,J], [(I,_), Sens, _]):- 
liste_pions([E,R,M,J], L), memberchk((I,_),L).

coup_possible([E,R,M,J], [(I,_), Sens, _]):- liste_pions([E,R,M,J], L), pion_libre(L), case_bord(I).

case_bord(11). case_bord(12). case_bord(13). case_bord(14). case_bord(15). 
case_bord(21). case_bord(31). case_bord(41). case_bord(51). 
case_bord(25). case_bord(35). case_bord(45). 
case_bord(52). case_bord(53). case_bord(54). case_bord(55). 

coup_possible([E,R,M,J], [Depart, Sens, _]):-case_suivante(Depart,Sens,I1), \+animaux_check((I1,_),[E,R,M,_]), \+memberchk(I1,M).

liste_pions([E,R,_,e], E).
liste_pions([E,R,_,r], R).


poussee_possible(P, [(I,O),Sens,NewO]):-poussee_possible(P, I, Sens, 1).
poussee_possible(P, I, O, X1):- case_suivante(I, O, I1), case_vide(P, I1),!.
poussee_possible(P, I, O, X1):-
	case_suivante(I, O, I1),
	compteur(P, I1, O, X),
	X2 is X1 + X,
	X2>0, poussee_possible(P, I1, O, X2).

compteur(P, I, O, 1):- animaux_check((I,O),P), !.
compteur(P, I, O, -1):- inverse_dir(O, O1), animaux_check((I,O1),P), !.
compteur([_,_,M,_], I, O, -0.9):- memberchk(I,M), !.
compteur(P, I, _, 0):- animaux_check((I,O1),P).

animaux_check((I,O),[E,_,_,_]):- memberchk((I,O),E), !.
animaux_check((I,O),[_,R,_,_]):- memberchk((I,O),R), !.

inverse_dir(n,s).
inverse_dir(s,n).
inverse_dir(e,o).
inverse_dir(o,e).

est_une_case(I):- I=<55, I>=11, X1 is I mod 10, X1=<5, X2 is I mod 10, X2>0.

case_nord(I,J):- J is I+10.
case_sud(I,J):- J is I-10.
case_est(I,J):- J is I+1.
case_ouest(I,J):- J is I-1.

case_suivante(I,n,I1):- est_une_case(I), case_nord(I,I1), !.
case_suivante(I,s,I1):- est_une_case(I), case_sud(I,I1), !.
case_suivante(I,e,I1):- est_une_case(I), case_est(I,I1), !.
case_suivante(I,o,I1):- est_une_case(I), case_ouest(I,I1), !.

case_vide([E,R,M,_],I):- \+animaux_check((I,_),[E,R,M,_]), \+memberchk(I,M).


remplacer([E,R,M,J], Case, NewCase, [NewPlateau,R,M,J]):- memberchk(Case,E), remplacer_case(E, Case, NewCase, NewPlateau),!.
remplacer([E,R,M,J], Case, NewCase, [E, NewPlateau, M, J]):- memberchk(Case,R), remplacer_case(R, Case, NewCase, NewPlateau),!.
remplacer([E,R,M,J], (I1,_), (I2,_), [E, R, NewPlateau, J]):- memberchk(I1,M), remplacer_case(M, I1, I2, NewPlateau).

remplacer_case([], _, _, []).
remplacer_case([I|Q], I, NewI, [NewI|Q]):-!.
remplacer_case([T|Q], I, NewI, [T|Q2]):-remplacer_case(Q, I, NewI, Q2).

jouer_coup(PlateauInitial, [(I,O),Sens,NewOrient], NouveauPlateau):- 
case_suivante(I, Sens, I1), 
jouer_coup_suivant(PlateauInitial, [(I1,_),Sens,_], NouveauPlateauTmp),
remplacer(NouveauPlateauTmp, (I,O), (I1,NewOrient), NouveauPlateau).

jouer_coup_suivant(PlateauInitial, [(I,_),Sens,_], NouveauPlateauTmp):-
animaux_check((I,O1),PlateauInitial),!,
jouer_coup(PlateauInitial,[(I,O1),Sens,O1],NouveauPlateauTmp).

jouer_coup_suivant([E,R,M,J], [(I,_),Sens,_], NouveauPlateauTmp):-
memberchk(I,M),!,
jouer_coup([E,R,M,J],[(I,m),Sens,_],NouveauPlateauTmp).

jouer_coup_suivant(PlateauInitial, _, PlateauInitial).





