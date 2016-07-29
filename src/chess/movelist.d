module chess.movelist;

import chess.move;

import core.sync.mutex : Mutex;
import std.container : Array;

// An array of moves. Will be what is returned when move generation is over.
struct MoveList
{
    Array!Move moves;
    Mutex lock;
    alias moves this;
}
