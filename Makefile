clean:
	rm *.o

main: main.o makeBoard.o printBoard.o print.o random.o printNum.o remDiv.o readInt.o INTerp.o checkGameOver.o modify.o input.o
	gcc -o $@ $^

%.o: %.s
	gcc -c -o $@ $^