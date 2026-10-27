#include "tokenizer.h"
#include "list.h"
#include "parser.h"
#include "misc.h"

char white[] = {"\t\r\n "};
char letters[] = {"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"};
char numbers[] = {"0123456789"};
char hex[] = {"0123456789ABCDEFabcdef"};
char reg[] = {"r0123456789"};
char stateTable[MAX_STATES][MAX_LINE];

char regNames[MAX_REGISTERS][5] = {	
	{"r0"},
	{"r1"},
	{"r2"},
	{"r3"},
	{"r4"},
	{"r5"},
	{"r6"},
	{"r7"},
	{"r8"},
	{"r9"},
	{"r10"},
	{"r11"},
	{"r12"},
	{"r13"},
	{"r14"},
	{"r15"},
	{"r16"},
	{"r17"},
	{"r18"},
	{"r19"},
	{"r20"},
	{"r21"},
	{"r22"},
	{"r23"},
	{"r24"},
	{"r25"},
	{"r26"},
	{"r27"},
	{"r28"},
	{"r29"},
	{"r30"},
	{"r31"}
};

char directives[MAX_DIRECTIVES][5] = {
	{"org"},
	{"equ"}
};

extern char instructions[MAX_INSTRUCTIONS][5];
extern unsigned char instOpcodes[MAX_INSTRUCTIONS];

void insertState(STATE from, STATE to, char *p)
{
	while(*p) {
		stateTable[from][(long)(*p++)] = to;		
	}
}

void buildTable(void)
{
	memset(stateTable, ERROR, sizeof(stateTable));
	insertState(STATE_START, STATE_ID, letters);
	insertState(STATE_START, STATE_WHITE, white);
	insertState(STATE_START, STATE_DECIMAL, numbers);
	insertState(STATE_START, STATE_COMMA, ",");
	insertState(STATE_START, STATE_IMM, "#");
	insertState(STATE_START, STATE_HEX, "$");

	insertState(STATE_WHITE, STATE_WHITE, white);	

	insertState(STATE_ID, STATE_ID, letters);
	insertState(STATE_ID, STATE_ID, numbers);
	insertState(STATE_ID, STATE_ID, "_");
	insertState(STATE_ID, STATE_LABEL, ":");

	insertState(STATE_HEX, STATE_HEX, hex);
	insertState(STATE_DECIMAL, STATE_DECIMAL, numbers);
}

TOKEN *tokenize(char *p)
{
	char *l;
	long length;
	long value;
	STATE state;
	long index = 0;
	char lex[MAX_LINE+1];
	TOKEN *head = NULL;
	TOKEN *tail = NULL;

	if(strlen(p) == 0) { // empty line
		return (TOKEN *)-2;
	}

	while(*p) {
		l = lex;
		length=0;
		state = STATE_START; // start the state machine from the start state
		while(stateTable[state][(long)*p] != ERROR && length < MAX_LINE) {
			*l++ = *p;	
			state = stateTable[state][(long)(*p++)]; // set new state based on input AND the current state
			length++;
		}
		*l='\0';		


		if(state == STATE_START) // found an invalid character
		return (TOKEN *)0;

		if(length >= MAX_LINE) // too many chracters in line
		return (TOKEN *)0;

		if(state != STATE_WHITE) { // do simple parsing on the tokens if they are not white spaces
			if(state == STATE_HEX) { // convert hex string to integer value
				sscanf(lex+1, "%lX", &value);
			} else if(state == STATE_DECIMAL) { // convert number string to integer
				sscanf(lex, "%ld", &value);
			} else if(state == STATE_ID) { // Might be an instruction
				if((value = findString(lex, instructions, MAX_INSTRUCTIONS)) != -1) { // recategorize the identifier as an instruction
					state = STATE_INSTRUCTION;
					index = value;					
					value = instOpcodes[value];
				} else if(findString(lex, directives, MAX_DIRECTIVES) != -1) { // recategorize the identifier as a directive
					state = STATE_DIRECTIVE;
				} else if(findString(lex, regNames, MAX_REGISTERS) != -1) { // recategorize the identifier as a register
					state = STATE_REGISTER;
					value = findString(lex, regNames, MAX_REGISTERS);

					if(value == -1) {
						return (TOKEN *)0;
					}
				}
			} else {
				value = 0;
			}

			if(state == STATE_LABEL) // remove the colon at the end if its a label
			lex[strlen(lex)-1] = '\0';

			tail = createNode(lex, state, value, index);						
			addNodeToList(&head, tail);						
		}
	}

	if(state == STATE_WHITE && head == 0) { // "empty line" it might really have white spaces and or tabs
		return (TOKEN *)-2;
	}

	return head;
}
