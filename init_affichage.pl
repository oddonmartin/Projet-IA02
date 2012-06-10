plateau_depart(X):- X =[[(0,0),(0,0),(0,0),(0,0),(0,0)],[(0,0),(0,0),(0,0),(0,0),(0,0)],
[32,33,34],e].

plateau_test(X):- X =[[(11,n),(31,e),(0,0),(55,o),(0,0)],[(0,0),(45,e),(34,o),(35,n),(0,0)],
[12,33,54],e].

affiche_plateau(X) :- ligne(1,X),!.

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