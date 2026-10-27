all:
	gcc -c tokenizer.c -Wall -g
	gcc -c list.c -Wall -g
	gcc -c parser.c -Wall -g
	gcc -c misc.c -Wall -g
	gcc crASM.c tokenizer.o list.o parser.o misc.o -o crASM -Wall -g

clean:
	rm -rf *.o *.coe crASM

