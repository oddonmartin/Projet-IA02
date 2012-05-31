poussee_possible(P, I, O, X1):- nl, write('case '), write(I), case_suivante(I, O, I1),
write(' case suivante '), write(I1), compteur(P, I1, O, X),write(' X= '), 
write(X),write(' X1= '), write(X1), X2 is X1 + X,write(' X2= '), write(X2), X2>=0, poussee_possible(P, I1, O, X2).

compteur(P, I, O, 1):- animaux_check((I,O),P), !.
compteur(P, I, O, -1):- inverse_dir(O, O1), animaux_check((I,O1),P), !.
compteur([_,_,M,_], I, O, -0.9):- memberchk(I,M), !.
compteur(P, I, _, 0):- animaux_check((I,O1),P), write(' ok ').
compteur(P, I, _, 0):- write(' fail '), fail.

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