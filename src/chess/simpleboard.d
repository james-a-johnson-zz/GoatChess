module chess.simpleboard;

import chess.defs;
import chess.position;

// Used in move generation.
struct SimpleBoard
{
    Piece[8][8] pieces;
    bool turn;
    ubyte castlePerm;
    Position enPas;
}
