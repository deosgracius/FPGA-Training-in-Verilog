#ifndef _LIST_
#define _LIST_

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tokenizer.h"

void addNodeToList(TOKEN **headT, TOKEN *node);
void freeNodes(TOKEN *t);
TOKEN *createNode(char *lex, long type, long value, long index);
TOKEN *findLast(TOKEN *head);

#endif
