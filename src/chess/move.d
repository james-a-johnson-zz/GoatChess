module chess.move;

import chess.defs;
import chess.position;

// Data structure for holding a move.
struct Move
{
    Piece piece;
    Piece capture;
    Piece promotion;

    Position from;
    Position to;
    Position enPas;

    ubyte castle;
}
