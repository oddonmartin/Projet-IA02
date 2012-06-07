% coup=[11,n,o]

coup_possible([E,R,M,J], [Depart, Sens, _]):-liste_pions([E,R,M,J], L), memberchk((I,_),L), case_suivante(Depart,Sens,I1), \+animaux_check((I1,_),[E,R,M,_]), \+memberchk(I1,M).

liste_pions([E,R,_,e], E).
liste_pions([E,R,_,r], R).


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


remplacer([E,_,_,_], Case, NewCase, NewPlateau):- memberchk(Case,E), remplacer_case(E, Case, NewCase, NewPlateau),!.
remplacer([_,R,_,_], Case, NewCase, NewPlateau):- memberchk(Case,R), remplacer_case(R, Case, NewCase, NewPlateau),!.
remplacer([_,_,M,_], Case, NewCase, NewPlateau):- memberchk(Case,M), remplacer_case(M, Case, NewCase, NewPlateau).

remplacer_case([], _, _, []).
remplacer_case([I|Q], I, NewI, [NewI|Q]):-!.
remplacer_case([T|Q], I, NewI, [T|Q2]):-remplacer_case(Q, I, NewI, Q2).

jouer_coup(PlateauInitial, [(I,0),Sens,NewOrient], NouveauPlateau):- case_suivante(I, Sens, I1), remplacer(PlateauInitial, [I,0], [I1,NewOrient], NouveauPlateau).



