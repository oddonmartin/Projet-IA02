/* Affichage et initialisation du plateau */

%siam.pl
:- include('init_affichage.pl').
:- include('moves.pl').
:- include('ia.pl').
:- initialization(depart(X)).

depart(X):-plateau_test(X), affiche_plateau(X).

test5(P):- plateau_test(P), affiche_plateau(P), poussee_possible(P,31,e,1).
test6(P):- plateau_test(P), affiche_plateau(P), coup_possible(P,[31,e,e]).
test7([E,R,J,M], P2):- plateau_test([E,R,J,M]), remplacer_case(E, (11,n), (55,e), P2).
test8(X, P2):- plateau_test(X), Coup=[(55,n),o,n], jouer_coup(X, Coup, P2), affiche_plateau(X), affiche_plateau(P2).


/* Jeu avec deux utilisateurs 
J1 : e, J2 : r => joueurs
*/
jeu_utilisateur([E,R,M,J]):-
	/* ajouter test si il reste des montagnes */
	demande_coup([E,R,M,J], Coup),
	coup_utilisateur([E,R,M,_], [NewE, NewR, NewM, _]),
	joueur_suivant(J,JoueurSuivant),
	jeu_utilisateur([NewE, NewR, NewM, JoueurSuivant]).

demande_case(X):- repeat, write('Entrez la case : '), read(X), est_une_case(X), !.
demande_sens(S):- repeat, write('Entrez le sens : '), read(S), est_une_orientation(S), !.
demande_orientation(O):- repeat, write('Entrez la nouvelle orientation : '), read(O), est_une_orientation(O), !.

est_une_orientation(n).
est_une_orientation(o).
est_une_orientation(s).
est_une_orientation(e).

demander_coup(P, [(Case, OrientationActuelle),Sens, NouvelleOrientation]):- 
	demander_case(Case), demander_orientation(NouvelleOrientation), 
	liste_pions(P, ListePions),
	animaux_check((Case, OrientationActuelle), ListePions), 
	demander_sens(Sens).
	
joueur_suivant(e,r).
joueur_suivant(r,e).

coup_utilisateur([E,R,M,J], NouveauPlateau):-
	demander_coup([E,R,M,J], Coup),
	coup_utilisateur([E,R,M,J],Coup, , NouveauPlateau).

coup_utilisateurPlateau, Coup, NouveauPlateau):-
	coup_possible(Plateau, Coup),!,
	jouer_coup(Plateau, Coup, NouveauPlateau).
	
coup_utilisateurPlateau, Coup, NouveauPlateau):-
	poussee_possible(Plateau, Coup), 
	jouer_coup(Plateau, Coup, NouveauPlateau).
	
	
	
	
	
	