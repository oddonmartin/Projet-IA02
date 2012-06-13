/* Jeu avec deux utilisateurs 
J1 : e, J2 : r => joueurs
*/


jeu_utilisateur([E,R,M,J]):-
	repeat,
	nl, write('Joueur '), write(J),nl,
	affiche_plateau([E,R,M,J]),
	demande_coup(Coup,[E,R,M,J]),
	coup_utilisateur([E,R,M,J], Coup,[NewE, NewR, NewM, _]),
	reste_montagnes(M, J),
	joueur_suivant(J,JoueurSuivant),!,
	jeu_utilisateur([NewE, NewR, NewM, JoueurSuivant]).

/* Demande du coup à l'utilisateur */
demande_case(X, P):- repeat, write('Entrez la case : '), read(X), est_une_case(X),!.
demande_sens(S):- repeat, write('Entrez le sens : '), read(S), est_une_orientation(S), !.
demande_orientation(O):- repeat, write('Entrez la nouvelle orientation : '), read(O), est_une_orientation(O), !.

est_une_orientation(n). est_une_orientation(o). est_une_orientation(s). est_une_orientation(e).

demande_coup([(Case, _),Sens, NouvelleOrientation],P):- 
	nl,demande_case(Case,P), 
	demande_sens(Sens),
	demande_orientation(NouvelleOrientation).	


joueur_suivant(e,r).
joueur_suivant(r,e).

pion_libre(L):-memberchk((0,0),L).

reste_montagnes([], J):-!, nl, write('L\'utilisateur '), write(J), write(' gagne !!'), nl, fail.
reste_montagnes([0|Q], J):-!,
	reste_montagnes(Q, J).
reste_montagnes([_|Q], _).



/* Demande et modification du plateau */

coup_utilisateur(Plateau, Coup, NouveauPlateau):-
	coup_possible(Plateau, Coup),
	poussee_possible(Plateau, Coup),
	jouer_coup(Plateau, Coup, NouveauPlateau).

