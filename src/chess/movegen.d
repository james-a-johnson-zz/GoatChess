module chess.movegen;

import chess.board;
import chess.position;

import std.container : Array;

// This is a simplified board that will be used in move generation.
struct SimpleBoard
{
    Piece[8][8] pieces;
    bool turn;
    ubyte castlePerm;
    Position enPas;
}

// Represents a single move.
struct Move
{
    Piece piece;
    Piece capture;

    Position from;
    Position to;
    Position enPas;

    ubyte castle;
}

// An array of moves. Will be what is returned when move generation is over.
alias MoveList = Array!Move;

MoveList genMoves(SimpleBoard sb)
{
    MoveList ml;

    for (int i = 0; i < 8; i++)
    {
        for (int j = 0; j < 8; j++)
        {
            if (sb.pieces[i][j] == Piece.empty)
                continue;
            else if (sb.pieces[i][j] == Piece.pawn && sb.turn)
                blackPawnGen(sb, ml, i, j);
            else if (sb.pieces[i][j] == Piece.knight && sb.turn)
                blackKnightGen(sb, ml, i, j);
            else if (sb.pieces[i][j] == Piece.bishop && sb.turn)
                blackBishopGen(sb, ml, i, j);
            else if (sb.pieces[i][j] == Piece.rook && sb.turn)
                blackRookGen(sb, ml, i, j);
            else if (sb.pieces[i][j] == Piece.queen && sb.turn)
                blackQueenGen(sb, ml, i, j);
            else if (sb.pieces[i][j] == Piece.king && sb.turn)
                blackKingGen(sb, ml, i, j);
            else if (sb.pieces[i][j] == Piece.Pawn && !sb.turn)
                whitePawnGen(sb, ml, i, j);
            else if (sb.pieces[i][j] == Piece.Knight && !sb.turn)
                whiteKnightGen(sb, ml, i, j);
            else if (sb.pieces[i][j] == Piece.Bishop && !sb.turn)
                whiteBishopGen(sb, ml, i, j);
            else if (sb.pieces[i][j] == Piece.Rook && !sb.turn)
                whiteRookGen(sb, ml, i, j);
            else if (sb.pieces[i][j] == Piece.Queen && !sb.turn)
                whiteQueenGen(sb, ml, i, j);
            else if (sb.pieces[i][j] == Piece.King && !sb.turn)
                whiteKingGen(sb, ml, i, j);
        }

    }

    return ml;
}

private:
void blackPawnGen(SimpleBoard sb, MoveList ml, int row, int col)
{
    Move m;
    m.from.row = row;
    m.from.column = col;
}

void blackKnightGen(SimpleBoard sb, MoveList ml, int row, int col)
{

}

void blackBishopGen(SimpleBoard sb, MoveList ml, int row, int col)
{

}

void blackRookGen(SimpleBoard sb, MoveList ml, int row, int col)
{

}

void blackQueenGen(SimpleBoard sb, MoveList ml, int row, int col)
{

}

void blackKingGen(SimpleBoard sb, MoveList ml, int row, int col)
{

}

void whitePawnGen(SimpleBoard sb, MoveList ml, int row, int col)
{

}

void whiteKnightGen(SimpleBoard sb, MoveList ml, int row, int col)
{

}

void whiteBishopGen(SimpleBoard sb, MoveList ml, int row, int col)
{

}

void whiteRookGen(SimpleBoard sb, MoveList ml, int row, int col)
{

}

void whiteQueenGen(SimpleBoard sb, MoveList ml, int row, int col)
{

}

void whiteKingGen(SimpleBoard sb, MoveList ml, int row, int col)
{

}
