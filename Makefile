clean:
	rm *.o

main: main.o makeBoard.s printBoard.s print.s
	gcc -o $@ $^

%.o: %.s
	gcc -c -o $@ $^