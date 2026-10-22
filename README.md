# TD - Stockage de matrices en C
Auteurs : Wanzire Tredy (nom_github), Lefebvre Alexandre (barnabastide) - TD2


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
## Vérifications mémoire
## Démonstration finale
## Bilans et difficultés

