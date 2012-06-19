/* Jeu avec deux utilisateurs 
J1 : e, J2 : r => joueurs
*/


jeu_utilisateur([E,R,M,J]):-
	repeat,
	nl, write('Joueur '), write(J),nl,
	affiche_plateau([E,R,M,J]), write([E,R,M,J]),
	demande_coup(Coup,[E,R,M,J],Entree),
	coup_utilisateur([E,R,M,J], Coup,[NewE, NewR, NewM, _],Entree),!,
	reste_montagnes(NewM, [NewE, NewR, NewM, J]),
	joueur_suivant(J,JoueurSuivant),
	jeu_utilisateur([NewE, NewR, NewM, JoueurSuivant]).

/* Demande du coup à l'utilisateur */
demande_case(X, _):- repeat, write('Entrez la case : '), read(X), est_une_case(X),!.
demande_sens(S):- repeat, write('Entrez le sens : '), read(S), \+var(S), est_une_orientation(S), !.
demande_orientation(O):- repeat, write('Entrez la nouvelle orientation : '), read(O), \+var(O), est_une_orientation(O), !.
demande_entree(Entree):- repeat, write('Voulez vous bouger le pion (0) ou faire entrer un nouveau pion (1) ? '), read(Entree), integer(Entree), est_1_ou_0(Entree), !.

est_1_ou_0(0). est_1_ou_0(1).
est_une_orientation(n). est_une_orientation(o). est_une_orientation(s). est_une_orientation(e).

demande_coup([(Case, _),Sens, NouvelleOrientation],[E,R,M,J],Entree):- 
	nl,
	demande_case(Case,[E,R,M,J]), 
	liste_pions([E,R,M,J],L),
	demande_coup([(Case, _),Sens, NouvelleOrientation],_,Entree,L).	

demande_coup([(Case, _),Sens, NouvelleOrientation],_,_,L):-
	\+memberchk((Case,_), L),!,
	demande_sens(Sens),
	demande_orientation(NouvelleOrientation).
	
demande_coup([(Case, _),Sens, NouvelleOrientation],P,Entree,L):-
	demande_entree(Entree),
	demande_coup2([(Case, _),Sens, NouvelleOrientation],P,Entree,L).
	
demande_coup2([(Case, _),Sens, NouvelleOrientation],_,1,_):-
	demande_sens(Sens),
	sens_ok(Case, Sens),
	demande_orientation(NouvelleOrientation).
	
demande_coup2([(_, _),Sens, NouvelleOrientation],_,0,_):-
	demande_sens(Sens),
	demande_orientation(NouvelleOrientation).


sens_ok(11, n). sens_ok(12, n). sens_ok(13, n). sens_ok(14, n). sens_ok(15, n). sens_ok(11, e). sens_ok(11, e). sens_ok(21, e). sens_ok(21, e). sens_ok(31, e). sens_ok(41, e). sens_ok(51, e). sens_ok(51, s). sens_ok(52, s). sens_ok(53, s). sens_ok(54, s). sens_ok(55, s). sens_ok(55, o). sens_ok(45, o). sens_ok(35, o). sens_ok(25, o). sens_ok(25, o). sens_ok(15, o).


joueur_suivant(e,r).
joueur_suivant(r,e).

pion_libre(L):-memberchk((0,0),L).

reste_montagnes([], [E,R,M,J]):-!, nl, write('L\'utilisateur '), write(J), write(' gagne !!'), nl, affiche_plateau([E,R,M,J]), fail.
reste_montagnes([0|Q], Plateau):-!,
	reste_montagnes(Q, Plateau).
reste_montagnes([_|_], _).



/* Demande et modification du plateau */

coup_utilisateur(Plateau, Coup, NouveauPlateau,Entree):-
	coup_possible(Plateau, Coup, Entree), /* Entree =1 si entrée sur le plateau, 0 sinon. */
	poussee_possible(Plateau, Coup),
	jouer_coup(Plateau, Coup, NouveauPlateau, Entree).

