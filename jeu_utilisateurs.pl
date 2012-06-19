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



coup_utilisateur(Plateau, Coup, NouveauPlateau,Entree):-
	coup_ok(Plateau, Coup, Entree),
	coup_utilisateur2(Plateau, Coup, NouveauPlateau,Entree),!,
	jouer_coup(Plateau, Coup, NouveauPlateau, Entree).

coup_utilisateur2(Plateau, Coup, NouveauPlateau,Entree):-coup_possible(Plateau, Coup).
coup_utilisateur2(Plateau, Coup, NouveauPlateau,Entree):-poussee_possible(Plateau, Coup).


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
	check_entree((Case,_),Sens,[E,R,M,J], Entree),
	demande_sens(Sens),
	demande_orientation(NouvelleOrientation).
	
check_entree((Case,_),Sens,[E,R,M,J], Entree):-
	case_bord(Case),
	liste_pions([E,R,M,J],L), memberchk((Case,_), L),!,
	demande_entree(Entree).
	
check_entree((Case,_),Sens,[E,R,M,J], 1):-
	case_bord(Case),
	joueur_suivant(J,J2),
	liste_pions([E,R,M,J2],L2), memberchk((Case,_), L2),!.
	
check_entree((Case,_),_,_, 1):-
	case_bord(Case),!.

check_entree(_,_,_,0).
	
case_bord(11). case_bord(12). case_bord(13). case_bord(14). case_bord(15). 
case_bord(21). case_bord(31). case_bord(41). case_bord(51). 
case_bord(25). case_bord(35). case_bord(45). 
case_bord(52). case_bord(53). case_bord(54). case_bord(55). 

sens_ok(11, n). sens_ok(12, n). sens_ok(13, n). sens_ok(14, n). sens_ok(15, n). sens_ok(11, e). sens_ok(21, e). sens_ok(21, e). sens_ok(31, e). sens_ok(41, e). sens_ok(51, e). sens_ok(51, s). sens_ok(52, s). sens_ok(53, s). sens_ok(54, s). sens_ok(55, s). sens_ok(55, o). sens_ok(45, o). sens_ok(35, o). sens_ok(25, o). sens_ok(25, o). sens_ok(15, o).


joueur_suivant(e,r).
joueur_suivant(r,e).

pion_libre(L):-memberchk((0,0),L).

reste_montagnes([], [E,R,M,J]):-!, nl, write('L\'utilisateur '), write(J), write(' gagne !!'), nl, affiche_plateau([E,R,M,J]), fail.
reste_montagnes([0|Q], Plateau):-!,
	reste_montagnes(Q, Plateau).
reste_montagnes([_|_], _).

	
	
	
	
/* jouer_coup, Cas entrée sur le plateau */
jouer_coup(PlateauInitial, [(I,_),Sens,NewOrient], NouveauPlateau, 1):- 
jouer_coup_suivant(PlateauInitial, [(I,_),Sens,_], NouveauPlateauTmp, 0),
liste_pions(NouveauPlateauTmp, Liste),
remplacer_case(Liste, (0,0), (I,NewOrient), NouvelleListe),
remplacer_case(NouveauPlateauTmp, Liste, NouvelleListe, NouveauPlateau).

/* jouer_coup, Cas normal */
jouer_coup(PlateauInitial, [(I,O),Sens,NewOrient], NouveauPlateau, 0):- 
case_suivante(I, Sens, I1), 
jouer_coup_suivant(PlateauInitial, [(I1,_),Sens,_], NouveauPlateauTmp, 0),
jouer_coup_2(NouveauPlateauTmp, [(I,O),Sens,NewOrient], NouveauPlateau).

jouer_coup_2(NouveauPlateauTmp, [(I,O),Sens,NewOrient], NouveauPlateau):-
case_suivante(I, Sens, I1),
est_une_case(I1),
liste_pions(NouveauPlateauTmp, L),
memberchk((I,O), L),!,
remplacer(NouveauPlateauTmp, (I,O), (I1,NewOrient), NouveauPlateau).

jouer_coup_2(NouveauPlateauTmp, [(I,O),Sens,NewOrient], NouveauPlateau):-
case_suivante(I, Sens, I1),
est_une_case(I1),
joueur_suivant(J,J2), liste_pions([E,R,M,J2], L2),
memberchk((I1,_), L2),!,
remplacer(NouveauPlateauTmp, (I,O), (I1,NewOrient), NouveauPlateau).

/* Cas où on bouge une montagne */
jouer_coup_2([E,R,M,J], [(I,_),Sens,_], [E,R,NewM,J]):-
memberchk(I,M),
case_suivante(I, Sens, I1),
est_une_case(I1),!,
remplacer_case(M, I, I1, NewM).

/* Cas d'une sortie du plateau */
jouer_coup_2(NouveauPlateauTmp, [(I,O),_,_], NouveauPlateau):-
remplacer(NouveauPlateauTmp, (I,O), (0,0), NouveauPlateau).

jouer_coup_suivant(PlateauInitial, [(I,_),Sens,_], NouveauPlateauTmp, Entree):-
animaux_check((I,O1),PlateauInitial),!,
jouer_coup(PlateauInitial,[(I,O1),Sens,O1],NouveauPlateauTmp,Entree).

jouer_coup_suivant([E,R,M,J], [(I,_),Sens,_], NouveauPlateauTmp, Entree):-
memberchk(I,M),!,
jouer_coup([E,R,M,J],[(I,m),Sens,_],NouveauPlateauTmp,Entree).

jouer_coup_suivant(PlateauInitial, _, PlateauInitial, _).

