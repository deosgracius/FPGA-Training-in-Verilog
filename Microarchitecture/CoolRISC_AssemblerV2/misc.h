#ifndef _MISC_
#define _MISC_

#include "list.h"
#include "parser.h"
#include "symtbl.h"

//#define DEBUG	1

long firstPass(FILE *fp, LBLTABLE *labels);
void readLine(FILE *fp, char *l);
long secondPass(FILE *fp, FILE *fpO, LBLTABLE *labels);
long findString(char *what, char where[][5], long length);

#endif
