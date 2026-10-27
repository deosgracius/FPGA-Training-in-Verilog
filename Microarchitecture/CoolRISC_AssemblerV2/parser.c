#include "parser.h"
#include "tokenizer.h"
#include "misc.h"

char instructions[MAX_INSTRUCTIONS][5] = {
	{"ld"},
	{"st"},
	{"add"},
	{"sub"},
	{"and"},
	{"or"},
	{"xor"},
	{"not"},
	{"sl"},
	{"sr"},
	{"jml"},
	{"bn"},
	{"bnn"},
	{"bv"},
	{"bnv"},
	{"bz"},
	{"bnz"},
	{"bra"},
	{"tst"},
	{"tfr"},
	{"gtb"},
	{"rti"}
};

char flipSRCDST[MAX_INSTRUCTIONS] = { 	// If there is a one here the first argument of the instruction is the source not the destination
	0, //LD				This is only valid for two argument instructions, no effect for others.
	1, //ST
	0, //ADD
	0, //SUB
	0, //AND
	0, //OR
	0, //XOR
	0, //NOT
	0, //SL
	0, //SR
	0, //JML
	0, //BN
	0, //BNN
	0, //BV
	0, //BNV
	0, //BZ
	0, //BNZ	
	0, //BRA
	1, //TST
	0, //TFR
	0, //GTB
	0
};

char instArgNumber[MAX_INSTRUCTIONS] = {
	2, //LD
	2, //ST
	3, //ADD
	3, //SUB
	3, //AND
	3, //OR
	3, //XOR
	2, //NOT
	3, //SL
	3, //SR
	2, //JML
	1, //BN
	1, //BNN
	1, //BV
	1, //BNV
	1, //BZ
	1, //BNZ
	1, //BRA
	2, //TST
	2, //TFR
	2, //GTB
	0
};

unsigned char instOpcodes[MAX_INSTRUCTIONS] = {
	0x01, //LD
	0x02, //ST
	0x03, //ADD
	0x04, //SUB
	0x05, //AND
	0x06, //OR
	0x07, //XOR
	0x08, //NOT
	0x09, //SL
	0x0A, //SR
	0x0B, //JML
	0x0C, //BN
	0x0D, //BNN
	0x0E, //BV
	0x0F, //BNV
	0x10, //BZ
	0x11, //BNZ
	0x12, //BRA
	0x13, //TST	
	0x14, //TFR
	0x15, //GTB
	0x16
};

long inst2ASCII(long opcode, long mode, long src, long dst, long literal)
{
	return ((opcode<<2 | mode)<<42)|((src<<5 | dst)<<32)|literal;
}

unsigned long findSymbol(LBLTABLE *labels, char *p) 
{
	long i;

	i=0;
	while(labels[i].label != 0 && !(strcmp(p, labels[i].label) == 0) && i<MAX_LABELS) {
		i++;
	}

	if(labels[i].label == 0) {
		return -1;
	}

	return labels[i].address;
}

long parseOneOperand(TOKEN *t, long num, LBLTABLE *labels)
{
	long src = 0;
	long dst = 0;
	long mode = DIRECT_MODE;
	long opcode = 0;
	long literal = 0;

	#ifdef DEBUG
	printf("Generated Code: %s ", t->lex);
	#endif
	opcode = t->value;

	if(t->next)
	t = t->next;
	else
	return -1;
	if(t->type == IMMEDIATE) {
		mode = IMMEDIATE_MODE;
		if(t->next)
		t = t->next;
		else
		return -1;
		if(t->type == HEX) {
			#ifdef DEBUG
			printf("#$%lX\n", t->value);
			#endif	
			literal = t->value;				
		} else if(t->type == DECIMAL) {
			#ifdef DEBUG
			printf("#%ld\n", t->value);
			#endif
			literal = t->value;
		} else if(t->type == ID) {
			#ifdef DEBUG
			printf("#$%lX\n", findSymbol(labels, t->lex));
			#endif
			literal = findSymbol(labels, t->lex);
		} else {
			return -1;			
		}
	} else if(t->type == HEX) {
		#ifdef DEBUG
		printf("$%lX\n", t->value);
		#endif	
		literal = t->value;		
	} else if(t->type == DECIMAL) {
		#ifdef DEBUG
		printf("%ld\n", t->value);			
		#endif		
		literal = t->value;
	} else if(t->type == REGISTER) {
		#ifdef DEBUG
		printf("r%ld\n", t->value);			
		#endif
		mode = REGISTER_MODE;
		src = t->value;
	} else {
		return -1;
	}

	#ifndef DEBUG
	return inst2ASCII(opcode, mode, src, dst, literal);
	#endif

	return 1;
}

long parseTwoOperands(TOKEN *t, long num, LBLTABLE *labels)
{
	long src = 0;
	long dst = 0;
	long mode = DIRECT_MODE;
	long opcode = 0;
	long literal = 0;
	long index = 0;

	#ifdef DEBUG
	printf("Generated Code: %s ", t->lex);
	#endif
	opcode = t->value;
	index = t->index;	

	if(t->next)
	t = t->next;
	else
	return -1;
	if(t->type == REGISTER) {
		#ifdef DEBUG
		printf("r%ld, ", t->value);
		#endif
		dst = t->value;
	} else {
		return -1;
	}

	if(t->next)
	t = t->next;
	else
	return -1;
	if(t->type != COMMA) {
		return -1;
	}

	if(t->next)
	t = t->next;
	else
	return -1;
	if(t->type == IMMEDIATE) {
		mode = IMMEDIATE_MODE;
		if(t->next)
		t = t->next;
		else
		return -1;
		if(t->type == HEX) {
			#ifdef DEBUG
			printf("#$%lX\n", t->value);			
			#endif
			literal = t->value;
		} else if(t->type == DECIMAL) {
			#ifdef DEBUG
			printf("#%ld\n", t->value);
			#endif
			literal = t->value;
		} else if(t->type == ID) {
			#ifdef DEBUG
			printf("#$%lX\n", findSymbol(labels, t->lex));
			#endif
			literal = findSymbol(labels, t->lex);
		} else {
			return -1;			
		}
	} else if(t->type == HEX) {
		#ifdef DEBUG
		printf("$%lX\n", t->value);			
		#endif
		literal = t->value;
	} else if(t->type == DECIMAL) {
		#ifdef DEBUG
		printf("%ld\n", t->value);			
		#endif
		literal = t->value;
	} else if(t->type == REGISTER) {
		#ifdef DEBUG
		printf("r%ld\n", t->value);
		#endif		
		mode = REGISTER_MODE;
		src = t->value;
	} else if(t->type == ID) {	
		#ifdef DEBUG		
		printf("$%lX\n", findSymbol(labels, t->lex));
		#endif

		literal = findSymbol(labels, t->lex);

		if(literal == -1) {
			return -1;
		}
	} else {
		return -1;
	}	
	
	#ifndef DEBUG
	if(flipSRCDST[index]) {
		return inst2ASCII(opcode, mode, dst, src, literal);
	} else {		
		return inst2ASCII(opcode, mode, src, dst, literal);
	}
	#endif
	
	return 1;
}

long parseThreeOperands(TOKEN *t, long num, LBLTABLE *labels)
{
	long src = 0;
	long dst = 0;
	long mode = DIRECT_MODE;
	long opcode = 0;
	long literal = 0;

	#ifdef DEBUG
	printf("Generated Code: %s ", t->lex);
	#endif
	opcode = t->value;

	if(t->next)
	t = t->next;
	else
	return -1;
	if(t->type == REGISTER) {
		#ifdef DEBUG
		printf("r%ld, ", t->value);
		#endif
		dst = t->value;
	} else {
		return -1;
	}

	if(t->next)
	t = t->next;
	else
	return -1;	
	if(t->type != COMMA) {
		return -1;
	}

	if(t->next)
	t = t->next;
	else
	return -1;
	if(t->type == REGISTER) {
		#ifdef DEBUG
		printf("r%ld, ", t->value);
		#endif
		src = t->value;
	} else {
		return -1;
	}

	if(t->next)
	t = t->next;
	else
	return -1;
	if(t->type != COMMA) {
		return -1;
	}

	if(t->next)
	t = t->next;
	else
	return -1;
	if(t->type == IMMEDIATE) {
		mode = IMMEDIATE_MODE;
	if(t->next)
	t = t->next;
	else
	return -1;
		if(t->type == HEX) {
			#ifdef DEBUG
			printf("#$%lX\n", t->value);			
			#endif
			literal = t->value;
		} else if(t->type == DECIMAL) {
			#ifdef DEBUG
			printf("#%ld\n", t->value);			
			#endif
			literal = t->value;
		} else if(t->type == REGISTER) {
			#ifdef DEBUG
			printf("r%ld\n", t->value);			
			#endif
			literal = t->value;
		} else if(t->type == ID) {
			#ifdef DEBUG
			printf("#$%lX\n", findSymbol(labels, t->lex));
			#endif
			literal = findSymbol(labels, t->lex);
		} else {
			return -1;
		}
	} else {
		if(t->type == REGISTER) {
			mode = REGISTER_MODE;
			#ifdef DEBUG
			printf("r%lX\n", t->value);
			#endif
			literal = t->value;
		} else {
			return -1;
		}
	}

	#ifndef DEBUG
	return inst2ASCII(opcode, mode, src, dst, literal);
	#endif

	return 1;
}

long parse(TOKEN *t, LBLTABLE *labels, FILE *fpO)
{
	long instNo;
	long numberOfArguments;
	long Opcode;

	if(t->type == INSTRUCTION) {
		if((instNo = findString(t->lex, instructions, MAX_INSTRUCTIONS)) != -1) {
			numberOfArguments = instArgNumber[instNo];

			if(numberOfArguments == 1) {
				Opcode = parseOneOperand(t, instNo, labels);
				if(Opcode != -1)
				fprintf(fpO, "DATA[]=49'h%lX;\n", Opcode);
				return Opcode;
			} else if(numberOfArguments == 2) {
				Opcode = parseTwoOperands(t, instNo, labels);
				if(Opcode != -1)
				fprintf(fpO, "DATA[]=49'h%lX;\n", Opcode);
				return Opcode;
			} else if(numberOfArguments == 3) {
				Opcode = parseThreeOperands(t, instNo, labels);
				if(Opcode != -1)
				fprintf(fpO, "DATA[]=49'h%lX;\n", Opcode);
				return Opcode;
			} else if(numberOfArguments == 0) {
				fprintf(fpO, "DATA[]=49'h%lX;\n", inst2ASCII(0x16, 0, 0, 0, 0));
				return 0x16;
			}
		} else {
			return -1;
		}
	}
	return 1;
}

long parseDirective(TOKEN *t, FILE *fpO, long *cAddr)
{
	long literal;

	if(t->next)
	t = t->next;
	else
	return -1;

	if(t->type == HEX) {
		#ifdef DEBUG
		printf("#$%lX\n", t->value);			
		#endif
		literal = t->value;
	} else if(t->type == DECIMAL) {
		#ifdef DEBUG
		printf("#%ld\n", t->value);			
		#endif
		literal = t->value;
	} else {
		return -1;
	}
			
	while((*cAddr)<literal) {
		(*cAddr)++;
		fprintf(fpO, "000000000000\n");		
	}

	return 1;
}

