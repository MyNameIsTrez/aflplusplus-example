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

NAME := example

CC := gcc

CFLAGS := -Wall -Wextra -Werror -Wpedantic -Wfatal-errors -Wconversion

OBJDIR := obj

ifdef DEBUG
CFLAGS += -g3
endif
# ifdef SAN
# CFLAGS += -fsanitize=address,undefined
# endif
ifdef AFL
NAME := example_afl
CC := afl-clang-lto
CFLAGS += -Wno-gnu-statement-expression -DAFL=1
OBJDIR := obj_afl
endif
ifdef CTMIN
NAME := example_ctmin
CC := afl-clang-lto
CFLAGS += -DCTMIN=1
OBJDIR := obj_ctmin
endif
ifdef GCOV
NAME := example_gcov
CC := afl-gcc-fast
CFLAGS += -Wno-gnu-statement-expression -fprofile-arcs -ftest-coverage -DGCOV=1
OBJDIR := obj_gcov
endif

CFILES := src/main.c

OBJFILES := $(addprefix $(OBJDIR)/,$(CFILES:c=o))

.PHONY: all
all: $(NAME)

$(NAME): $(OBJFILES)
	@$(CC) $(CFLAGS) $(OBJFILES) -o $(NAME)

$(OBJDIR)/%.o : %.c
	@mkdir -p $(@D)
	@$(CC) $(CFLAGS) -c $< -o $@

.PHONY: clean
clean:
	@rm -rf afl

	@rm -rf obj
	@rm -rf obj_afl
	@rm -rf obj_ctmin
	@rm -rf obj_gcov

	@rm -f example
	@rm -f example_afl
	@rm -f example_ctmin
	@rm -f example_gcov

.PHONY: re
re: clean all
