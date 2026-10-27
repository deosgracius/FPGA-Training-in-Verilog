#ifndef _SYMTBL_
#define _SYMTBL_

#define MAX_LABELS	1000
#define MAX_LABEL_SIZE	100

typedef struct labelTable {
	char *label;
	unsigned long address;
} LBLTABLE;

#endif
