#ifndef _TOKENIZER_
#define _TOKENIZER_

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_LINE	256
#define MAX_STATES	11
#define ERROR		-1
#define MAX_REGISTERS	32
#define MAX_DIRECTIVES	2

typedef enum {
	NUL0, ID, NUL1, REGISTER, COMMA, IMMEDIATE, HEX, DECIMAL, LABEL, INSTRUCTION, DIRECTIVE             
} TYPE;

typedef enum {
	STATE_START, STATE_ID, STATE_WHITE, STATE_REGISTER, STATE_COMMA, STATE_IMM, STATE_HEX, 
	STATE_DECIMAL, STATE_LABEL, STATE_INSTRUCTION, STATE_DIRECTIVE
} STATE;

typedef struct token {
	TYPE type;
	char lex[MAX_LINE];
	long value;
	long index;
	struct token *next;
} TOKEN;

void buildTable(void);
void insertState(STATE from, STATE to, char *p);
TOKEN *tokenize(char *p);

#endif
