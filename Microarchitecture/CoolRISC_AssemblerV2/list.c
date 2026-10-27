#include "list.h"

TOKEN *createNode(char *lex, long type, long value, long index)
{
	TOKEN *t = (TOKEN *)malloc(sizeof(TOKEN));
	if(!t) {
		printf("Error allocating memory for new node\n");
		return (TOKEN *)0;
	}

	t->type = type;
	strcpy(t->lex, lex);
	t->value = value;
	t->index = index;
	t->next = NULL;

	return t;
}

TOKEN *findLast(TOKEN *head)
{
	while(head->next) {
		head = head->next;
	}

	return head;
}

void addNodeToList(TOKEN **headT, TOKEN *node)
{
	TOKEN *last;

	if(!(*headT)) {
		*headT = node;
	} else {
		last = findLast(*headT);
		last->next = node;
	}
}

void freeNodes(TOKEN *t)
{
	if(t) {
		freeNodes(t->next);
		free(t);
	}
}

