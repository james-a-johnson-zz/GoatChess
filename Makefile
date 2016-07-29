CC = ldc2
FLAGS = -O2 -boundscheck=on -enable-asserts -enable-color -enable-inlining \
		-enable-contracts -m64 -unittest -w -wi -I=/home/jaj/Documents/dlang/chess/src \
		-d-debug

BIN = ./bin/goatchess
OBJECTS = $(subst src, build, $(patsubst %.d, %.o, $(wildcard src/*.d)))
CHESS = src/chess/board.d src/chess/position.d src/chess/movegen.d

.PHONY: all clean run

all: $(OBJECTS) build/chess.a
	$(CC) $(FLAGS) -of=$(BIN) $(OBJECTS) ./build/chess.a

build/main.o: src/main.d
	$(CC) $(FLAGS) -of=./build/main.o -c src/main.d

build/chess.a: $(CHESS)
	$(CC) $(FLAGS) -od=./build -of=./build/chess.a -lib $(CHESS)

run: $(BIN)
	./$(BIN)

clean:
	rm ./$(BIN)
	rm ./build/*.o
	rm ./build/*.a
	rm -rf ./build/src
