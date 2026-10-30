# TD - Stockage de matrices en C
Auteurs : Wanzire Tredy (Tredy-5), Lefebvre Alexandre (barnabastide) - TD2


## Introduction
L'objectif de ce TD est de créer une bibliothèque C découpée en modules permettant de créer, lire, écrire, sauvegarder et faire des calculs sur des matrices d'entiers (addition et multiplication). Au travers de ce TD, nous avons pu comprendre :
  - La séparation entre le contrat, décrit dans le fichier .h, et son implémentation dans le fichier .c ;
  - La compilation séparée de plusieurs modules avant assemblage avec l'édition de liens ;
  - Comment allouer et libérer dynamiquement de la mémoire afin de créer des matrices, mêmes partiels ;
  - Fractionner un projet de façon modulaire pour que chaque fichier remplisse un rôle précis ;
  - Vérifier le code crée par une gestion des erreurs et de multiples tests.

Nous avons été capable de finir entièrement ce TD, comprenant la validité syntaxique des 4 exercices, les résultats voulus pour chaque fichier, et une libération totale de la mémoire allouée.
    
## Conception
<img width="539" height="223" alt="Graphe_inclusions" src="https://github.com/user-attachments/assets/54463501-5762-4c6e-82a4-9d2ac5008a22" />

Img 1 - Graphe des inclusions entre fichiers, avec comme règle que X -> Y signifie : "X contient #include Y".

Au cours de ce TD, nous avons pu en apprendre davantage sur les règles à suivre concernant l'utilisation de la mémoire :
  - Toujours définir une variable tout juste déclarée à NULL (dans notre cas, à MATRICE_VIDE) ;
  - C'est au client de libérer la mémoire qui a été déclaré par les fonctions ;
  - Un flot ouvert à un moment donné signifie forcément une fermeture de ce flot ensuite (principe de "Tout ou rien") ;
  - Une fonction qui échoue au milieu du code doit libérer tout ce qu'elle a alloué plus tôt.
    
## Réalisation
### Exercice 1

Code complété de l'exercice 1 : 
```
/* (1.a) À COMPLÉTER : Compléter les cas d'erreurs de dimensions et de dépassement */
case MAT_ERR_DIMENSIONS:  return "dimensions incompatibles";
case MAT_ERR_DEPASSEMENT: return "résultat hors de l'intervalle";

/* (1.b) À COMPLÉTER : renvoyer 1 si les QUATRE conditions suivantes
 *       sont vraies, 0 sinon :
 *         - m n'est pas NULL ;
 *         - m->coef n'est pas NULL ;
 *         - 1 <= m->nb_lignes <= MAT_DIM_MAX ;
 *         - 1 <= m->nb_colonnes <= MAT_DIM_MAX.
 *       Une seule instruction suffit :
 *         return m != NULL && m->coef != NULL && ... ;            */
return m!=NULL
&& m->coef !=NULL
&& m->nb_lignes >= 1 && m->nb_lignes <= MAT_DIM_MAX
&& m->nb_colonnes >= 1 && m->nb_colonnes <= MAT_DIM_MAX;

/* (1.c) À COMPLÉTER : si nb_lignes ou nb_colonnes n'est pas compris
 *       entre 1 et MAT_DIM_MAX, renvoyer MAT_ERR_ARGUMENT.          */
if(nb_lignes < 1 || nb_lignes > MAT_DIM_MAX || nb_colonnes < 1 || nb_colonnes > MAT_DIM_MAX){
    return MAT_ERR_ARGUMENT;
}


/* (1.d) À COMPLÉTER : allouer chaque ligne. */
for (int i = 0; i < nb_lignes; i++) {
    coef[i] = mat_calloc((size_t)nb_colonnes, sizeof *coef[i]);    // nb_colonnes entiers
    if (coef[i] == NULL) {
        for (int k = i - 1; k >= 0; k--)  // lignes déjà
            free(coef[k]);                // obtenues
        free(coef);                       // puis le tableau
     return MAT_ERR_ALLOCATION;
    }
 }

/* (1.e) À COMPLÉTER : maintenant que tout a réussi, remplir *res
 *       (trois affectations : coef, nb_lignes, nb_colonnes)
 *       et renvoyer MAT_OK.                                        */

res->coef = coef;
res->nb_lignes = nb_lignes;
res->nb_colonnes = nb_colonnes;
return MAT_OK;

/* (1.f) À COMPLÉTER : si m->coef n'est pas NULL :
 *         - libérer chaque ligne m->coef[i], i de 0 à nb_lignes - 1 ;
 *         - PUIS libérer le tableau m->coef lui-même.              */
if (m->coef != NULL){
    for(int i=0;i<m->nb_lignes; i++){
            free(m->coef[i]);
    }
    free(m->coef);
}
```

Q3.1 : Si l’on avait pris en paramètre une Matrice m dans la fonction matrice_detruire, alors seule la copie, crée par la fonction, et ce vers quoi elle pointe aurait été libérée, et non pas la « vraie » matrice. On utilise alors Matrice *m pour avoir accès à la « vraie » matrice et ainsi la modifier.

Q3.2 : Pour une matrice de taille nxp, dans notre code, on commence d’abord par allouer à l’entier coef un tableau de n lignes. Ensuite, on alloue dans chaque case un tableau d’entiers, de taille p au total. Ainsi, le nombre total d’appels à calloc pour une matrice nxp est égale à 1+n= n+1.
Pour libérer entièrement la mémoire, il faut faire l’étape d’initialisation dans le sens inverse, et commencer par free ce qui se trouve dans les n cases du tableau (dans notre cas, un pointeur vers un tableau d’entiers). Après cela, on peut libérer le tableau dans son entièreté, ce qui nous donne un nombre total d’appels à free égale à n+1.
Si la k-ieme itération échoue, alors les (k-1)-ièmes premières itérations ont fonctionné. On commence alors par libérer ces k-1 premières cases du tableau, avant de libérer le tableau dans son entièreté, d’où un total de k libérations. 

Q3.3 : Appeler deux fois matrice_detruire sur la même matrice est sans danger car on regarde en premier si cette matrice est nulle ou non, avant de libérer la mémoire. 
Si on fait une copie d’une matrice et que l’on libère les deux avec free, alors on doit s’attendre à ce que le compilateur renvoie une erreur. En effet, on libère deux fois la même zone mémoire, d’où l’erreur.

Q3.4 : On commence par mettre *res à MATRICE_VIDE pour faire face au cas où la fonction échoue. De cette façon, la personne qui a appelé la fonction n’a pas à libérer de mémoire.

Sortie de l'exercice 1 :
```=== Exercice 1 : matrice.c ===
[OK]    (1.a) message pour MAT_ERR_DIMENSIONS
[OK]    (1.a) message pour MAT_ERR_DEPASSEMENT
[OK]    (1.b) une matrice 1 x 2 est valide
[OK]    (1.b) NULL n'est pas valide
[OK]    (1.b) MATRICE_VIDE n'est pas valide
[OK]    (1.b) une matrice de 0 ligne n'est pas valide
=== Exercice 1 : matrice_alloc.c ===
[OK]    (1.c) mat_allouer refuse 0 ligne
[OK]    (1.c) mat_allouer refuse -2 colonnes
[OK]    (1.c) mat_allouer refuse une dimension > MAT_DIM_MAX
[OK]    (1.e) mat_allouer(&m, 3, 4) renvoie MAT_OK
[OK]    (1.e) m a 3 lignes et 4 colonnes
[OK]    (1.d) tous les coefficients valent 0
[OK]    (1.f) apres mat_detruire, m est vide
[OK]    (1.f) un second mat_detruire est sans danger
[OK]    (1.f) mat_detruire(NULL) ne plante pas
=== Exercice 1 : echecs d'allocation simules ===
[OK]    (1.d) chaque echec renvoie MAT_ERR_ALLOCATION et laisse *res vide

Bilan : 16 / 16 verifications reussies.
```

### Exercice 2

Code de l'exercice 2 complété : 
```
/* (2.a) À COMPLÉTER : pour chaque ligne i, afficher chaque
 *       coefficient avec printf(" %8d", m->coef[i][j]),
 *       puis passer à la ligne avec putchar('\n').               */
for(int i=0; i<m->nb_lignes;i++){
    for(int j=0; j<m->nb_colonnes;j++){
            printf("%8d", m->coef[i][j]);
    }
    putchar('\n');
}

/* (2.b) À COMPLÉTER : pour chaque ligne i de la matrice :
 *         - écrire les coefficients séparés par UN espace :
 *             le premier (j == 0) avec "%d", les autres avec " %d" ;
 *         - terminer la ligne avec fputc('\n', f) ;
 *         - si un fprintf renvoie un nombre < 0, ou si fputc
 *           renvoie EOF : return MAT_ERR_ECRITURE;               */
for(int i=0; i<m->nb_lignes;i++){
    for(int j=0;j<m->nb_colonnes;j++){
            if (fprintf(f, j==0 ? "%d" : " %d", m->coef[i][j]) < 0){
                    return MAT_ERR_ECRITURE;
            }
    }
    if (fputc('\n', f) == EOF){
            return MAT_ERR_ECRITURE;
    }
}

/* (2.c) À COMPLÉTER : si nb_lignes ou nb_colonnes n'est pas compris
 *       entre 1 et MAT_DIM_MAX, renvoyer MAT_ERR_FORMAT
 *       (c'est le contenu du fichier qui est faux).               */
if (nb_lignes < 1 || nb_lignes > MAT_DIM_MAX || nb_colonnes < 1 || nb_colonnes > MAT_DIM_MAX){
    return MAT_ERR_FORMAT;
}

/* (2.d) À COMPLÉTER : déclarer une matrice LOCALE et l'allouer :
 *         Matrice tmp;
 *         err = mat_allouer(&tmp, nb_lignes, nb_colonnes);
 *         if (err != MAT_OK) return err;                          */
Matrice tmp;
err = mat_allouer(&tmp, nb_lignes, nb_colonnes);
if (err != MAT_OK){
    return err;
}

/* (2.e) À COMPLÉTER : deux boucles imbriquées (i, puis j) qui lisent
 *       chaque coefficient avec lire_entier(f, &tmp.coef[i][j]).
 *       Si une lecture échoue :
 *         mat_detruire(&tmp);  return err;                        */
for(int i=0; i< nb_lignes; i++){
    for(int j=0; j< nb_colonnes; j++){
            err = lire_entier(f, &tmp.coef[i][j]);
            if(err != MAT_OK){
                    mat_detruire(&tmp);
                    return err;
            }
    }
}

/* (2.f) À COMPLÉTER : tout a réussi, on transfère le résultat :
 *         *res = tmp;  return MAT_OK;                             */
*res = tmp;
return MAT_OK;
```

Q4.1 : Si on remplit directement *res dans la fonction mat_lire, l'utilisateur peut obtenir un résultat à moitié fini, si une erreur arrive pendant la fonction. Ainsi, on remplit une matrice locale pour éviter ce souci, étant donné qu’on ne l’affecte à *res que si elle est complète.

Q4.2 : La fonction mat_lire ne vérifie pas que chaque ligne de la matrice est sur sa ligne de texte, mais la fonction d’écriture vérifie cela. Ce n’est pas gênant puisque cela est justifié par le principe « tolérant en lecture, strict en écriture ». Ce principe indique que notre programme doit savoir faire face à de petits défauts quand il reçoit des données, mais se doit de respecter à la lettre les règles établis. C’est donc ce principe qui est mis en place.

Q4.3 : Comme le flux est positionné au niveau du dernier coefficient lors de l’appel à mat_lire, on peut faire en sorte de stocker plusieurs matrices en faisant d’abord un retour à la ligne pour positionner le flux à la ligne du dessous, avant de refaire un appel à mat_lire pour lire cette deuxième matrice.

Q4.4 : La fonction mat_ecrire fait appel à fflush afin de synchroniser le tampon apportant des modifications et le fichier texte où l’on souhaite écrire, car certaines modifications dans le tampon peuvent ne pas être appliqués au fichier. Cependant, cela n’empêche pas l’appelant d’utiliser fclose après utilisation car fflush ne ferme pas le flux ouvert au début par fopen.

Sortie de l'exercice 2 :
```=== Exercice 2 : affichage (verification visuelle) ===
M (4 x 3) :
       1       2       3
       4       5       6
       7       8       9
      10      11      12
(2.a) Vous devez voir ci-dessus 4 lignes : 1 2 3 / 4 5 6 / 7 8 9 / 10 11 12
=== Exercice 2 : ecriture ===
[OK]    ouverture de test_ex2_sortie.txt en ecriture
[OK]    (2.b) mat_ecrire renvoie MAT_OK
[OK]    (2.b) le fichier contient exactement le format attendu
[OK]    (2.b) mat_ecrire refuse une matrice vide
=== Exercice 2 : relecture ===
[OK]    (2.f) mat_lire relit le fichier : MAT_OK
[OK]    (2.e) la matrice relue est identique
[OK]    (2.e) espaces et sauts de ligne en trop sont toleres
=== Exercice 2 : fichiers incorrects ===
[OK]    (2.c) fichier vide
[OK]    (2.c) dimension nulle
[OK]    (2.c) dimension negative
[OK]    (2.e) coefficient manquant
[OK]    (2.e) donnee non numerique
[OK]    (2.e) entier trop grand pour un int
=== Exercice 2 : echec d'allocation simule ===
[OK]    (2.d) mat_lire renvoie MAT_ERR_ALLOCATION proprement

Bilan : 14 / 14 verifications reussies.
```

### Exercice 3

Code de l'exercice 3 complété : 
```
/* (3.a) À COMPLÉTER : si a et b n'ont pas le même nombre de lignes
 *       OU pas le même nombre de colonnes,
 *       renvoyer MAT_ERR_DIMENSIONS.                              */
if( a->nb_lignes != b->nb_lignes || a->nb_colonnes != b->nb_colonnes){
    return MAT_ERR_DIMENSIONS;
}

/* (3.b) À COMPLÉTER : allouer r avec les dimensions de a ;
 *         err = mat_allouer(&r, ..., ...);
 *         if (err != MAT_OK) return err;                          */
Matrice r = MATRICE_VIDE;
err = mat_allouer(&r, a->nb_lignes, a->nb_colonnes);
if(err != MAT_OK){
    return err;
}

/* (3.c) À COMPLÉTER : calculer la somme des coefficients
 *       (i, j) de a et de b EN long long :
 *         long long s = (long long)a->coef[i][j] + ... ;  */
long long s = (long long)a->coef[i][j] + b->coef[i][j];

/* (3.d) À COMPLÉTER : transférer le résultat :
 *         *res = r;  return MAT_OK;                               */
*res =r;
return MAT_OK;

/* (3.e) À COMPLÉTER : le produit a x b n'existe que si le nombre de
 *       COLONNES de a est égal au nombre de LIGNES de b.
 *       Sinon, renvoyer MAT_ERR_DIMENSIONS.                       */
if( a->nb_colonnes != b->nb_lignes){
    return MAT_ERR_DIMENSIONS;
}

/* (3.f) À COMPLÉTER : allouer r de dimensions
 *       (lignes de a) x (colonnes de b).                          */
Matrice r = MATRICE_VIDE;
err = mat_allouer(&r, a->nb_lignes, b->nb_colonnes);
if (err != MAT_OK){
    return err;
}

/* (3.g) À COMPLÉTER : boucle sur k, de 0 à a->nb_colonnes - 1,
 *       qui ajoute à s le produit a(i,k) x b(k,j) :
 *
 *   for (int k = 0; k < a->nb_colonnes; k++) {
 *       long long p = (long long)a->coef[i][k] * b->coef[k][j];
 *       if ((p > 0 && s > LLONG_MAX - p)
 *           || (p < 0 && s < LLONG_MIN - p)) {
 *           mat_detruire(&r);
 *           return MAT_ERR_DEPASSEMENT;
 *       }
 *       s += p;
 *   }                                                     */
for (int k = 0; k < a->nb_colonnes; k++) {
    long long p = (long long)a->coef[i][k] * b->coef[k][j];
    if ((p > 0 && s > LLONG_MAX - p) || (p < 0 && s < LLONG_MIN - p)){
            mat_detruire(&r);
            return MAT_ERR_DEPASSEMENT;
    }
    s +=p;
}
```

Q5.1 : L’attribut const permet d’empêcher toute modification d’une variable. Dans notre cas, const Matrice *a protège la valeur pointée par a, donc une Matrice, mais le pointeur a la possibilité de pointer ailleurs, et donc n’empêche pas a->coef[0][0] = 7. Afin de l’empêcher, il faut écrire const Matrice const *a, ce qui va empêcher le pointeur et l’adresse de pouvoir être modifiés.

Q5.2 : Si l’on acceptait A <- A+B, on perdrait la matrice A de départ, qui serait alors remplacée par le résultat de l’addition dans le fichier texte.

Q5.3 : La multiplication d’une matrice nxp avec une matrice pxq renvoie une matrice nxq, donc composée de de nxq coefficients. Pour calculer le coefficient placé à la ième ligne et la jème colonne , on a besoin de multiplier la ligne i de la première matrice, composée de p coefficients, avec la colonne j de la deuxième matrice, composée elle aussi de p coefficients. Ainsi, le calcul d’un seul coefficient demande p multiplications. La matrice renvoyée étant de taille nxq, le nombre de multiplications effectuées par mat_multiplier est égale à nxpxq.
Pour deux matrices de taille 1000x1000, il y aura alors 1000x1000x1000 = 10 puissance 9 multiplications.

Q5.4 : Ce test permet de détecter un dépassement positif, une valeur plus grande que INT_MAX. Cependant, cela ne détecte pas si s est inférieure ou non à INT_MIN, ce qui fausserait le résultat si c’était le cas. 

Sortie de l'exercice 3 :
```=== Exercice 3 : addition ===
[OK]    (3.a) (2 x 3) + (3 x 2) : MAT_ERR_DIMENSIONS
[OK]    (3.d) (2 x 3) + (2 x 3) : MAT_OK
[OK]    (3.c) a + b est correct
[OK]    a et b n'ont pas ete modifiees
[OK]    (3.b) le resultat possede sa propre memoire
[OK]    (3.c) INT_MAX + 1 : MAT_ERR_DEPASSEMENT
=== Exercice 3 : multiplication ===
[OK]    (3.e) (2 x 3) x (2 x 3) : MAT_ERR_DIMENSIONS
[OK]    (3.h) (2 x 3) x (3 x 2) : MAT_OK
[OK]    (3.g) a x c = (58 64 / 139 154)
[OK]    (3.f) (3 x 2) x (2 x 3) donne une matrice 3 x 3
[OK]    a et c n'ont pas ete modifiees
[OK]    (3.g) 2 x 10^10 depasse INT_MAX : MAT_ERR_DEPASSEMENT
=== Exercice 3 : cas particuliers ===
[OK]    resultat = entree refuse, a reste intacte
[OK]    (3.f) echec d'allocation : MAT_ERR_ALLOCATION, r vide

Bilan : 14 / 14 verifications reussies.
```

### Exercice 4

Code de l'exercice 4 complété : 
```
/* (4.a) À COMPLÉTER : afficher A et B avec mat_afficher.          */
mat_afficher("A", &a);
mat_afficher("B", &b);

/* (4.b) À COMPLÉTER : calculer r.
 *         MatErreur err = addition ? mat_additionner(&a, &b, &r)
 *                                  : mat_multiplier(&a, &b, &r);
 *       Si err != MAT_OK : afficher sur stderr un message utilisant
 *       mat_message_erreur(err) et les dimensions de A et de B,
 *       puis : goto nettoyage;                                    */

MatErreur err = addition ? mat_additionner(&a, &b, &r)
                         : mat_multiplier(&a, &b, &r);
if(err != MAT_OK){
    fprintf(stderr, "Erreur : calcul impossible : %s", 
            mat_message_erreur(err));
    fprintf(stderr, "(A : %d x %d, B : %d x %d)\n", a.nb_lignes, 
            a.nb_colonnes, b.nb_lignes, b.nb_colonnes);
    goto nettoyage;
}

/* (4.c) À COMPLÉTER : afficher r (nom "R = A + B" ou "R = A x B").  */
addition ? mat_afficher("R = A + B", &r) : mat_afficher("R = A x B", &r);

/* (4.d) À COMPLÉTER : tout a réussi :
 *         - afficher "Résultat enregistré dans \"...\"." ;
 *         - statut = EXIT_SUCCESS;                                 */
printf("Résultat enregistré dans \"%s\".\n", argv[4]);
return EXIT_SUCCESS;
```

Q6.1 : Le fichier main.c est le cerveau de notre ensemble de fichiers, son rôle est d’appeler les autres fichiers et de faire le lien entre ces fichiers et l’utilisateur qui les utilisent. Ainsi, ce n’est pas à la fonction mat_lire de renvoyer un message d’erreur car elle ne s’occupe pas de la passerelle code-utilisateur. C’est le fichier main.c qui s’en occupe et qui décide de l’affichage de cette erreur.

Q6.2 : On applique à nouveau le principe de tolérance en lecture et d’intransigeance en écriture. La fonction charger ne fait que lire la matrice dans un fichier, tandis que la fonction sauvegarder écrit une matrice dans un fichier.

Q6.3 : Le calcul ayant réussi, on a donc alloué de la mémoire pour trois matrices, à savoir celles que l’on additionne ou multiplie, et la matrice contenant le résultat. Cette libération se fait à l’aide de nettoyage, à la fin du main.

## Vérifications mémoire
## Démonstration finale
## Bilans et difficultés
Nous n'avons pas eu beaucoup de difficultés lors de la réalisation de ce TD. En revanche, nous avons pu nous rendre compte de la rigueur à adopter afin de gérer convenablement la mémoire dynamique.
Nous nous sommes répartis le travail de la manière suivante : 
  - Lefebvre Alexandre : Écriture du code, exécution des tests sur les 4 modules et réponse aux questions de réflexion
  - Wanzire Tredy : Réponse aux questions de réflexion et rédaction du compte-rendu

Lefebvre Alexandre a utilisé Internet afin de comprendre ce qu'était le principe "Tolérant en lecture, strict en écriture".
    
