CC = ldc2
FLAGS = -O2 -boundscheck=on -enable-asserts -enable-color -enable-inlining \
		-enable-contracts -m64 -unittest -w -wi -I=/home/jaj/Documents/dlang/GoatChess/src \
		-d-debug -gc -v-cg -op -oq

BIN = ./bin/goatchess
OBJECTS = $(subst src, build, $(patsubst %.d, %.o, $(wildcard src/*.d)))
CHESS = $(wildcard src/chess/*.d)
PLAYER = $(wildcard src/player/*.d)

.PHONY: all clean run

all: $(OBJECTS) build/chess.a build/player.a
	$(CC) $(FLAGS) -of=$(BIN) $(OBJECTS) ./build/chess.a ./build/player.a

build/main.o: src/main.d
	$(CC) $(FLAGS) -of=./build/main.o -c src/main.d

build/game.o: src/game.d
	$(CC) $(FLAGS) -of=./build/game.o -c src/game.d

build/chess.a: $(CHESS)
	$(CC) $(FLAGS) -od=./build -of=./build/chess.a -lib $(CHESS)

build/player.a: $(PLAYER)
	$(CC) $(FLAGS) -od=./build -of=./build/player.a -lib $(PLAYER)

run: $(BIN)
	./$(BIN)

clean:
	rm ./$(BIN)
	rm ./build/*.o
	rm ./build/*.a
	rm -rf ./build/src
