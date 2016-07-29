module chess.queen;

import chess.defs;
import chess.move;
import chess.movelist;
import chess.position;
import chess.simpleboard;

import chess.bishop;
import chess.rook;

import core.sync.mutex;

void blackQueenGen(immutable SimpleBoard sb, ref MoveList ml, int row, int col)
{
    blackBishopGen(sb, ml, row, col);
    blackRookGen(sb, ml, row, col);
}

void whiteQueenGen(immutable SimpleBoard sb, ref MoveList ml, int row, int col)
{
    whiteBishopGen(sb, ml, row, col);
    whiteRookGen(sb, ml, row, col);
}
