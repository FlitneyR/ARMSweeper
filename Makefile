clean:
	rm *.o

main: main.o makeBoard.s printBoard.s print.s random.s printNum.s remDiv.s readInt.s INTerp.s
	gcc -o $@ $^

%.o: %.s
	gcc -c -o $@ $^