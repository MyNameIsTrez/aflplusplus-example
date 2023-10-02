# **************************************************************************** #
#                                                                              #
#                                                         ::::::::             #
#    Makefile                                           :+:    :+:             #
#                                                      +:+                     #
#    By: vbenneko <vbenneko@student.codam.nl>         +#+                      #
#                                                    +#+                       #
#    Created: 2022/08/16 13:58:57 by vbenneko      #+#    #+#                  #
#    Updated: 2023/01/19 16:09:46 by vbenneko      ########   odam.nl          #
#                                                                              #
# **************************************************************************** #

NAME := miniRT

CC := gcc

CFLAGS := -Wall -Wextra -Werror -Wpedantic -Wfatal-errors -Wconversion

OBJDIR := obj

ifdef DEBUG
CFLAGS += -g3
endif
ifdef SAN
CFLAGS += -fsanitize=address
endif
ifdef AFL
CC := afl-clang-lto
CFLAGS += -Wno-gnu-statement-expression -DAFL=1
endif
ifdef CTMIN
NAME := miniRT_ctmin
CC := afl-clang-lto
CFLAGS += -DCTMIN=1
OBJDIR := obj_ctmin
endif
ifdef GCOV
NAME := miniRT_gcov
CC := afl-gcc-fast
CFLAGS += -Wno-gnu-statement-expression -fprofile-arcs -ftest-coverage -DGCOV=1
OBJDIR := obj_gcov
endif

CFILES :=\
	src/main.c

INCLUDES :=
OBJFILES := $(addprefix $(OBJDIR)/,$(CFILES:c=o))

ifeq ($(shell uname),Darwin)
LIB_FLAGS := -l glfw3 -framework Cocoa -framework OpenGL -framework IOKit
else
# CFLAGS := -Wall -Wextra -Wpedantic -Wfatal-errors -Wconversion -Wno-gnu-statement-expression
LIB_FLAGS := -l glfw
endif

all: $(NAME)

$(NAME): $(OBJFILES)
	@$(CC) $(CFLAGS) $(OBJFILES) $(LIB_FLAGS) -o $(NAME)
	@printf "Compiled %s\n" "$(NAME)"

$(OBJDIR)/%.o : %.c
	@mkdir -p $(@D)
	@$(call tidy_compilation,$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@)

clean:
	@rm -rf $(OBJDIR)
	@printf "Cleaned %s\n" "$(NAME)"

fclean: clean
	@rm -f $(NAME)
	@printf "Deleted %s\n" "$(NAME)"

re: fclean all

define tidy_compilation
	@printf "%s\e[K\n" "$(1)"
	@$(1)
	@printf "\e[A\e[K"
endef

.PHONY: all clean fclean re
