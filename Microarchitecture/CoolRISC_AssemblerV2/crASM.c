#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tokenizer.h"
#include "list.h"
#include "parser.h"
#include "symtbl.h"
#include "misc.h"

int main(int argc, char **argv)
{
	if(argc<3) {
		printf("Syntax: crASM input.asm output.coe\n");
		return -1;
	}

	FILE *fp;
	FILE *fpO;
	LBLTABLE labels[MAX_LABELS];

	fp = fopen(argv[1], "r");
	if(!fp) {
		printf("Could not open Input File\n");
		return -1;
	}	

	if(firstPass(fp, labels) == -1) {
		fclose(fp);
		return -1;
	}

	fpO = fopen(argv[2], "w");
	if(!fpO) {
		fclose(fp);
		printf("Could not open Output File\n");
		return -1;
	}

	// Make the COE Header
	//fprintf(fpO, "%s\n", "memory_initialization_radix=16;");
	//fprintf(fpO, "%s", "memory_initialization_vector = ");

	if(secondPass(fp, fpO, labels) == -1) {
		fclose(fp);
		fclose(fpO);
		return -1;
	}

	//fprintf(fpO, "%s\n", ";");	
	
	fclose(fp);
	fclose(fpO);
	printf("Success!\n");

	return 1;
}


