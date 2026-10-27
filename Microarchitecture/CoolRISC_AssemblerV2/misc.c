#include "misc.h"

extern char directives[MAX_DIRECTIVES][5];

void readLine(FILE *fp, char *l)
{
	char c = '\0';

	while(c!='\n' && c!='\r' && !feof(fp) && c != ';') {
		c = fgetc(fp);
		*l++ = c;
	}

	while(c!='\n' && c!='\r' && !feof(fp)) { // Exhaust all characters in the line in case a comment was found
		c = fgetc(fp);
	}

	*(--l) = '\0';
}

long findString(char *what, char where[][5], long length) 
{
	long i;

	i=0;
	while(!(strcmp(what, where[i]) == 0) && i<length) {
		i++;
	}

	if(i>=length) {
		return -1;
	}

	return i;
}

long firstPass(FILE *fp, LBLTABLE *labels)
{
	TOKEN *t;
	TOKEN *temp;
	long lineNo = 0;
	long addr = 0;
	long index = 0;
	char line[MAX_LINE];

	buildTable();
	while(!feof(fp)) {
		readLine(fp, line);
		lineNo++;
		if(!feof(fp)) {
			t = tokenize(line);
			if(!t) {
				printf("Invalid Character at line %ld\n", lineNo);				
				return -1;
			} else if(t == (TOKEN *)-2) {
				continue;
			}						

			if(t->type == ID) {
				labels[index].label = (char *)malloc(MAX_LABEL_SIZE);
				strcpy(labels[index].label, t->lex);

				temp = t->next;

				if(temp->type == DIRECTIVE && findString(temp->lex, directives, MAX_DIRECTIVES) != -1) {
					temp = temp->next;
					labels[index].address = temp->value;
					index++;				
				} else {
					printf("Invalid Token at line %ld\n", lineNo);
					return -1;
				}
			}

			if(t->type == LABEL) {
				labels[index].label = (char *)malloc(MAX_LABEL_SIZE);

				if(!labels[index].label) {
					printf("Unable to initialize memory for label\n");
					return -1;
				}

				strcpy(labels[index].label, t->lex);
				labels[index].address = addr;
				index++;
			}

			if(t->type == DIRECTIVE) {
				if(findString(t->lex, directives, MAX_DIRECTIVES) != -1) {
					temp = t->next;
					addr = temp->value;
				} else {
					printf("Directive not found at line %ld\n", lineNo);
					return -1;
				}
			}	

			if(t->type == INSTRUCTION) {
				addr++;		
			}

			freeNodes(t);
		}
	}

	return 1;
}

long secondPass(FILE *fp, FILE *fpO, LBLTABLE *labels)
{
	TOKEN *t;
	long lineNo = 0;
	char line[MAX_LINE];
	long cAddr = 0;

	lineNo=0;
	fseek(fp, 0, SEEK_SET);
	while(!feof(fp)) {
		readLine(fp, line);
		lineNo++;
		if(!feof(fp)) {	
			t = tokenize(line);

			if(!t) {
				printf("Invalid Character at line %ld\n", lineNo);
				return -1;
			} else if(t == (TOKEN *)-2) {
				continue;
			}

			if(strcmp(t->lex, "org")) { 
				if(parse(t, labels, fpO) == -1) {
					printf("Parsing failed at line %ld\n", lineNo);
					return -1;
				}

				if(t->type == INSTRUCTION) // It could have been a definition so dont increment the address
				cAddr++;
			} else { // It must be a directive, only ORG working right now
				if(parseDirective(t, fpO, &cAddr) == -1) {
					printf("Parsing directive failed at line %ld\n", lineNo);
					return -1;
				}
			}

			freeNodes(t);
		}
	}

	return 1;
}
