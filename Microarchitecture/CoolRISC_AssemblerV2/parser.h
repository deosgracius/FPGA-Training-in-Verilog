#ifndef _PARSER_
#define _PARSER_

#include "tokenizer.h"
#include "symtbl.h"

#define MAX_INSTRUCTIONS	23

enum modes {
	IMMEDIATE_MODE, DIRECT_MODE, REGISTER_MODE
};

long parse(TOKEN *t, LBLTABLE *labels, FILE *fpO);
long parseThreeOperands(TOKEN *t, long num, LBLTABLE *labels);
long parseTwoOperands(TOKEN *t, long num, LBLTABLE *labels);
long parseOneOperand(TOKEN *t, long num, LBLTABLE *labels);
unsigned long findSymbol(LBLTABLE *labels, char *p);
long inst2ASCII(long opcode, long mode, long src, long dst, long literal);
long parseDirective(TOKEN *t, FILE *fpO, long *cAddr);

#endif
