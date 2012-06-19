:- include('moves.pl').

append(L1,L2,L3,L4,L5,L6,L7):- append(L1,L2,Liste1), append(Liste1,L3,Liste2),append(Liste2,L4,Liste3),
append(Liste3,L5,Liste4),append(Liste4,L6,L7).


supprime(_,[],[]).
supprime(X,[X|R],RsansX):- !,supprime(X,R,RsansX).
supprime(X,[P|R],[P|RsansX]):- supprime(X,R,RsansX),!.


liste_cases_depart([[],_,_,e],[]).
liste_cases_depart([E,_,_,e],L) :- supprime((0,0),E,L).

liste_cases_depart([[],_,_,r],[]).
liste_cases_depart([_,R,_,r],L) :- supprime((0,0),R,L).


coup_possible2(P,Depart,Sens,[]):- \+coup_possible(P,[Depart,Sens,_]),!.
coup_possible2(_,Depart,Sens,[[Depart,Sens,n],[Depart,Sens,s],[Depart,Sens,e],[Depart,Sens,o]]).

poussee_possible2(P,Depart,Sens,[]):- \+coup_possible2(P,Depart,Sens,[]).
poussee_possible2(P,Depart,Sens,[]):- \+poussee_possible(P,[(Depart,_),Sens,_]).
poussee_possible2(_,Depart,Sens,[[Depart,Sens,Sens]]).

coups_possibles(_,[],[]).
coups_possibles(P,[(Depart,Sens)|Y],ListeCoupsPossibles):- 
coups_possibles(P,Y,ListeCoupsPossibles2),
coup_possible2(P,Depart,n,L1), 
coup_possible2(P,Depart,s,L2),
coup_possible2(P,Depart,e,L3),  
coup_possible2(P,Depart,o,L4), 
poussee_possible2(P,Depart,Sens,L5),
append(L1,L2,L3,L4,L5,ListeCoupsPossibles2,ListeCoupsPossibles).


coups_possibles(P, ListeCoupsPossibles):- liste_cases_depart(P,L), write(L), coups_possibles(P, L, ListeCoupsPossibles).