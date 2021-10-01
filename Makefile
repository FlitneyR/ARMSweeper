clean:
	rm *.o

main: main.o makeBoard.s printBoard.s print.s random.s
	gcc -o $@ $^

%.o: %.s
	gcc -c -o $@ $^