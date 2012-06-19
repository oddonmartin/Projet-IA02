
/* exemple de coup=[11,n,o] */


/* coup_ok vérifie si le joueur veut jouer un de ses pions ou en faire entrer un */
coup_ok(P, [(I,_), Sens, _], 0):- 
	liste_pions(P, L), memberchk((I,_),L),!.
	
coup_ok([E,R,M,J], [(I,_), _, _], 1):- 
	liste_pions([E,R,M,J], L), 
	pion_libre(L), 
	case_bord(I).

coup_ok(_,_,_):- !, 
	nl, write('Mauvaise entrée, veuillez recommencer'), nl, fail.

	
/* coup_possible vérfie qu'il n'y a pas de pions sur la case suivante */
coup_possible(P, [(I,_), Sens, _]):- 
	case_suivante(I,Sens,I1),
	\+animaux_check((I,_),P).




/* poussee_possible vérifie que la poussee des autres pions est possible à l'aide d'un compteur */
poussee_possible(P, [(I,Sens),Sens,_]):-poussee_possible(P, I, Sens, 1).
poussee_possible(P, I, O, _):- case_suivante(I, O, I1), case_vide(P, I1),!.
poussee_possible(P, I, O, X1):-
	case_suivante(I, O, I1),
	compteur(P, I1, O, X),
	X2 is X1 + X,
	X2>0, poussee_possible(P, I1, O, X2).


compteur(P, I, O, 1):- animaux_check((I,O),P), !.
compteur(P, I, O, -1):- inverse_dir(O, O1), animaux_check((I,O1),P), !.
compteur([_,_,M,_], I, _, -0.9):- memberchk(I,M), !.
compteur(P, I, _, 0):- animaux_check((I,_),P).

animaux_check((I,O),[E,_,_,_]):- memberchk((I,O),E), !.
animaux_check((I,O),[_,R,_,_]):- memberchk((I,O),R), !.

inverse_dir(n,s).
inverse_dir(s,n).
inverse_dir(e,o).
inverse_dir(o,e).

est_une_case(I):- integer(I), I=<55, I>=11, X1 is I mod 10, X1=<5, X2 is I mod 10, X2>0.

case_nord(I,J):- J is I+10.
case_sud(I,J):- J is I-10.
case_est(I,J):- J is I+1.
case_ouest(I,J):- J is I-1.

case_suivante(I,n,I1):- est_une_case(I), case_nord(I,I1), !.
case_suivante(I,s,I1):- est_une_case(I), case_sud(I,I1), !.
case_suivante(I,e,I1):- est_une_case(I), case_est(I,I1), !.
case_suivante(I,o,I1):- est_une_case(I), case_ouest(I,I1), !.

case_vide([E,R,M,_],I):- \+animaux_check((I,_),[E,R,M,_]), \+memberchk(I,M).

liste_pions([E,_,_,e], E).
liste_pions([_,R,_,r], R).



/* MODIFICATION DU PLATEAU */

remplacer([E,R,M,J], Case, NewCase, [NewPlateau,R,M,J]):- memberchk(Case,E), remplacer_case(E, Case, NewCase, NewPlateau),!.
remplacer([E,R,M,J], Case, NewCase, [E, NewPlateau, M, J]):- memberchk(Case,R), remplacer_case(R, Case, NewCase, NewPlateau),!.
remplacer([E,R,M,J], (I1,_), (I2,_), [E, R, NewPlateau, J]):- memberchk(I1,M), remplacer_case(M, I1, I2, NewPlateau).

remplacer_case([], _, _, []).
remplacer_case([I|Q], I, NewI, [NewI|Q]):-!.
remplacer_case([T|Q], I, NewI, [T|Q2]):-remplacer_case(Q, I, NewI, Q2).
