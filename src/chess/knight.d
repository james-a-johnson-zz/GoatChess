module chess.knight;

import chess.defs;
import chess.move;
import chess.movelist;
import chess.position;
import chess.simpleboard;

import core.sync.mutex;

void blackKnightGen(immutable SimpleBoard sb, ref MoveList ml, int row, int col)
{
    Move m;
    m.from.row = row;
    m.from.col = col;

    m.piece = Piece.knight;

    if (row + 1 < 8 && col + 2 < 8 && (sb.pieces[row+1][col+2] > Piece.king || sb.pieces[row+1][col+1] == Piece.empty))
    {
        m.to.row = row + 1;
        m.to.col = col + 2;
        m.capture = sb.pieces[row+1][col+2];
        synchronized (ml.lock)
            ml.insertBack(m);
    }

    if (row + 2 < 8 && col + 1 < 8 && (sb.pieces[row+2][col+1] > Piece.king || sb.pieces[row+2][col+1] == Piece.empty))
    {
        m.to.row = row + 2;
        m.to.col = col + 1;
        m.capture = sb.pieces[row+2][col+1];
        synchronized (ml.lock)
            ml.insertBack(m);
    }

    if (row - 2 > -1 && col + 1 < 8 && (sb.pieces[row-2][col+1] > Piece.king || sb.pieces[row-2][col+1] == Piece.empty))
    {
        m.to.row = row - 2;
        m.to.col = col + 1;
        m.capture = sb.pieces[row-2][col+1];
        synchronized (ml.lock)
            ml.insertBack(m);
    }

    if (row - 1 > -1 && col + 2 < 8 && (sb.pieces[row-1][col+2] > Piece.king || sb.pieces[row-1][col+2] == Piece.empty))
    {
        m.to.row = row - 1;
        m.to.col = col + 2;
        m.capture = sb.pieces[row-1][col+2];
        synchronized (ml.lock)
            ml.insertBack(m);
    }

    if (row - 1 > -1 && col - 2 > -1 && (sb.pieces[row-1][col-2] > Piece.king || sb.pieces[row-1][col-2] == Piece.empty))
    {
        m.to.row = row - 1;
        m.to.col = col - 2;
        m.capture = sb.pieces[row-1][col-2];
        synchronized (ml.lock)
            ml.insertBack(m);
    }

    if (row - 2 > -1 && col - 1 > -1 && (sb.pieces[row-2][col-1] > Piece.king || sb.pieces[row-2][col-1] == Piece.empty))
    {
        m.to.row = row - 2;
        m.to.col = col - 1;
        m.capture = sb.pieces[row-2][col-1];
        synchronized (ml.lock)
            ml.insertBack(m);
    }

    if (row + 2 < 8 && col - 1 > -1 && (sb.pieces[row+2][col-1] > Piece.king || sb.pieces[row+2][col-1] == Piece.empty))
    {
        m.to.row = row + 2;
        m.to.col = col - 1;
        m.capture = sb.pieces[row+2][col-1];
        synchronized (ml.lock)
            ml.insertBack(m);
    }

    if (row + 1 < 8 && col - 2 > -1 && (sb.pieces[row+1][col-2] > Piece.king || sb.pieces[row+1][col-2] == Piece.empty))
    {
        m.to.row = row + 1;
        m.to.col = col - 2;
        m.capture = sb.pieces[row+1][col-2];
        synchronized (ml.lock)
            ml.insertBack(m);
        m.capture = Piece.empty;
    }
}

void whiteKnightGen(immutable SimpleBoard sb, ref MoveList ml, int row, int col)
{
    Move m;
    m.from.row = row;
    m.from.col = col;

    m.piece = Piece.Knight;

    if (row + 1 < 8 && col + 2 < 8 && sb.pieces[row+1][col+2] < Piece.Pawn)
    {
        m.to.row = row + 1;
        m.to.col = col + 2;
        m.capture = sb.pieces[row+1][col+2];
        synchronized (ml.lock)
            ml.insertBack(m);
    }

    if (row + 2 < 8 && col + 1 < 8 && sb.pieces[row+2][col+1] < Piece.Pawn)
    {
        m.to.row = row + 2;
        m.to.col = col + 1;
        m.capture = sb.pieces[row+2][col+1];
        synchronized (ml.lock)
            ml.insertBack(m);
    }

    if (row - 2 > -1 && col + 1 < 8 && sb.pieces[row-2][col+1] < Piece.Pawn)
    {
        m.to.row = row - 2;
        m.to.col = col + 1;
        m.capture = sb.pieces[row-2][col+1];
        synchronized (ml.lock)
            ml.insertBack(m);
    }

    if (row - 1 > -1 && col + 2 < 8 && sb.pieces[row-1][col+2] < Piece.Pawn)
    {
        m.to.row = row - 1;
        m.to.col = col + 2;
        m.capture = sb.pieces[row-1][col+2];
        synchronized (ml.lock)
            ml.insertBack(m);
    }

    if (row - 1 > -1 && col - 2 > -1 && sb.pieces[row-1][col-2] < Piece.Pawn)
    {
        m.to.row = row - 1;
        m.to.col = col - 2;
        m.capture = sb.pieces[row-1][col-2];
        synchronized (ml.lock)
            ml.insertBack(m);
    }

    if (row - 2 > -1 && col - 1 > -1 && sb.pieces[row-2][col-1] < Piece.Pawn)
    {
        m.to.row = row - 2;
        m.to.col = col - 1;
        m.capture = sb.pieces[row-2][col-1];
        synchronized (ml.lock)
            ml.insertBack(m);
    }

    if (row + 2 < 8 && col - 1 > -1 && sb.pieces[row+2][col-1] < Piece.Pawn)
    {
        m.to.row = row + 2;
        m.to.col = col - 1;
        m.capture = sb.pieces[row+2][col-1];
        synchronized (ml.lock)
            ml.insertBack(m);
    }

    if (row + 1 < 8 && col - 2 > -1 && sb.pieces[row+1][col-2] < Piece.Pawn)
    {
        m.to.row = row + 1;
        m.to.col = col - 2;
        m.capture = sb.pieces[row+1][col-2];
        synchronized (ml.lock)
            ml.insertBack(m);
    }
}
