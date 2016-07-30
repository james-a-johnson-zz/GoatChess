module chess.pawn;

import chess.defs;
import chess.move;
import chess.movelist;
import chess.position;
import chess.simpleboard;

import core.sync.mutex;

void blackPawnGen(immutable SimpleBoard sb, ref MoveList ml, int row, int col)
{
    assert(row >= 0 && row <= 8);

    Move m;
    m.from.row = row;
    m.from.col = col;

    m.piece = Piece.pawn;
    m.capture = Piece.empty;
    m.enPas.row = -1;
    m.enPas.col = -1;
    m.castle = 0;

    if (sb.pieces[row+1][col] == Piece.empty)
    {
        m.to.row = row + 1;
        m.to.col = col;
        if (row + 1 == 8)
        {
            synchronized (ml.lock)
            {
                m.promotion = Piece.queen;
                ml.insertBack(m);
                m.promotion = Piece.rook;
                ml.insertBack(m);
                m.promotion = Piece.bishop;
                ml.insertBack(m);
                m.promotion = Piece.knight;
                ml.insertBack(m);
            }
            m.promotion = Piece.empty;
        }
        else
        {
            synchronized (ml.lock)
                ml.insertBack(m);
        }

        if (row == 1 && sb.pieces[3][col] == Piece.empty)
        {
            m.to.row = 3;
            m.to.col = col;
            m.enPas.row = 2;
            m.enPas.col = col;
            synchronized (ml.lock)
                ml.insertBack(m);
            m.enPas.row = -1;
            m.enPas.col = -1;
        }
    }

    if (col - 1 > -1 && sb.pieces[row+1][col-1] > Piece.king)
    {
        m.to.row = row + 1;
        m.to.col = col - 1;
        m.capture = sb.pieces[row+1][col-1];
        if (row + 1 == 8)
        {
            synchronized (ml.lock)
            {
                m.promotion = Piece.queen;
                ml.insertBack(m);
                m.promotion = Piece.rook;
                ml.insertBack(m);
                m.promotion = Piece.bishop;
                ml.insertBack(m);
                m.promotion = Piece.knight;
                ml.insertBack(m);
            }
            m.promotion = Piece.empty;
        }
        else
        {
            synchronized (ml.lock)
                ml.insertBack(m);
        }
        m.capture = Piece.empty;
    }

    if (col + 1 < 8 && sb.pieces[row+1][col+1] > Piece.king)
    {
        m.to.row = row + 1;
        m.to.col = col + 1;
        m.capture = sb.pieces[row+1][col+1];
        if (row + 1 == 8)
        {
            synchronized (ml.lock)
            {
                m.promotion = Piece.queen;
                ml.insertBack(m);
                m.promotion = Piece.rook;
                ml.insertBack(m);
                m.promotion = Piece.bishop;
                ml.insertBack(m);
                m.promotion = Piece.knight;
                ml.insertBack(m);
            }
            m.promotion = Piece.empty;
        }
        else
        {
            synchronized (ml.lock)
                ml.insertBack(m);
        }
        m.capture = Piece.empty;
    }

    if ((row + 1 == sb.enPas.row) && (col - 1 == sb.enPas.col || col + 1 == sb.enPas.col))
    {
        m.to.row = sb.enPas.row;
        m.to.col = sb.enPas.col;
        ml.insertBack(m);
    }
}

void whitePawnGen(immutable SimpleBoard sb, ref MoveList ml, int row, int col)
{
    assert(row >= 0 && row <= 8);

    Move m;
    m.from.row = row;
    m.from.col = col;

    m.piece = Piece.Pawn;
    m.capture = Piece.empty;
    m.enPas.row = -1;
    m.enPas.col = -1;
    m.castle = 0;

    if (sb.pieces[row-1][col] == Piece.empty)
    {
        m.to.row = row-1;
        m.to.col = col;
        if (row - 1 == 0)
        {
            synchronized (ml.lock)
            {
                m.promotion = Piece.Queen;
                ml.insertBack(m);
                m.promotion = Piece.Rook;
                ml.insertBack(m);
                m.promotion = Piece.Bishop;
                ml.insertBack(m);
                m.promotion = Piece.Knight;
                ml.insertBack(m);
            }
            m.promotion = Piece.empty;
        }
        else
        {
            synchronized (ml.lock)
                ml.insertBack(m);
        }

        if (row == 6 && sb.pieces[4][col] == Piece.empty)
        {
            m.to.row = 4;
            m.to.col = col;
            m.enPas.row = 5;
            m.enPas.col = col;
            synchronized (ml.lock)
                ml.insertBack(m);
            m.enPas.row = -1;
            m.enPas.col = -1;
        }
    }

    if (col - 1 > -1 && sb.pieces[row-1][col-1] < Piece.Pawn && sb.pieces[row-1][col-1] != Piece.empty)
    {
        m.to.row = row - 1;
        m.to.col = col - 1;
        m.capture = sb.pieces[row-1][col-1];
        if (row - 1 == 0)
        {
            synchronized (ml.lock)
            {
                m.promotion = Piece.Queen;
                ml.insertBack(m);
                m.promotion = Piece.Rook;
                ml.insertBack(m);
                m.promotion = Piece.Bishop;
                ml.insertBack(m);
                m.promotion = Piece.Knight;
                ml.insertBack(m);
            }
            m.promotion = Piece.empty;
        }
        else
        {
            synchronized (ml.lock)
                ml.insertBack(m);
        }
        m.capture = Piece.empty;
    }

    if (col + 1 < 8 && sb.pieces[row-1][col+1] < Piece.Pawn && sb.pieces[row-1][col+1] != Piece.empty)
    {
        m.to.row = row - 1;
        m.to.col = col + 1;
        m.capture = sb.pieces[row-1][col+1];
        if (row - 1 == 0)
        {
            synchronized (ml.lock)
            {
                m.promotion = Piece.Queen;
                ml.insertBack(m);
                m.promotion = Piece.Rook;
                ml.insertBack(m);
                m.promotion = Piece.Bishop;
                ml.insertBack(m);
                m.promotion = Piece.Knight;
                ml.insertBack(m);
            }
            m.promotion = Piece.empty;
        }
        else
        {
            synchronized (ml.lock)
                ml.insertBack(m);
        }
        m.capture = Piece.empty;
    }

    if ((row - 1 == sb.enPas.row) && (col - 1 == sb.enPas.col && col + 1 == sb.enPas.col))
    {
        m.to.row = sb.enPas.row;
        m.to.col = sb.enPas.col;
        synchronized (ml.lock)
            ml.insertBack(m);
    }
}
