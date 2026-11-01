# ==============================================================================
# VARIABLES DE CONFIGURATION
# ==============================================================================

# Compilateur à utiliser
CC = gcc

# Options de compilation (Flags)
# -Wall -Wextra -Wpedantic : Affiche un maximum d'avertissements (warnings) pour un code propre
# -g            : Inclut les symboles de débogage (indispensable pour Valgrind/GDB)
# -std=c11      : Utilise la norme C11
CFLAGS = -Wall -Wextra -Wpedantic -g -std=c11

# Nom de l'exécutable final
TARGET = demo_matrices

# Détection automatique de tous les fichiers sources (.c) du dossier
SRCS = $(wildcard *.c)

ifeq ($(GITHUB_ACTIONS), true)
    SRCS = $(filter-out test_ex1.c, $(ALL_SRCS))
else
    SRCS = $(ALL_SRCS)
endif

# ==============================================================================
# RÈGLES DE COMPILATION
# ==============================================================================

# Règle par défaut (exécutée en tapant simplement 'make')
all: $(TARGET)

# Compilation DIRECTE : Crée l'exécutable directement depuis les fichiers .c
$(TARGET): $(SRCS)
	$(CC) $(CFLAGS) -o $(TARGET) $(SRCS)

# ==============================================================================
# RÈGLES UTILITAIRES
# ==============================================================================

# Nettoyage des fichiers temporaires (.o)
clean:
	rm -f $(OBJS)

# Nettoyage complet (fichiers objets + exécutable)
fclean: clean
	rm -f $(TARGET)

# Recompiler entièrement le projet
re: fclean all

# Indique à Make que ces règles ne sont pas des fichiers réels
.PHONY: all clean fclean re

