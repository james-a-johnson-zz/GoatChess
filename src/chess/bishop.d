module chess.bishop;

import chess.defs;
import chess.move;
import chess.movelist;
import chess.position;
import chess.simpleboard;

import core.sync.mutex;

void blackBishopGen(immutable SimpleBoard sb, ref MoveList ml, int row, int col)
{
    int i = void;

    Move m;
    m.from.row = row;
    m.from.col = col;

    m.piece = sb.pieces[row][col];
    m.capture = Piece.empty;

    for (i = 1; i < 8; i++)
    {
        if (row + i < 8 && col + i < 8)
        {
            if (sb.pieces[row+i][col+i] == Piece.empty)
            {
                m.to.row = row + i;
                m.to.col = col + i;
                synchronized (ml.lock)
                    ml.insertBack(m);
                continue;
            }
            else if (sb.pieces[row+i][col+i] > Piece.king)
            {
                m.to.row = row + i;
                m.to.col = col + i;
                m.capture = sb.pieces[row+i][col+i];
                synchronized (ml.lock)
                    ml.insertBack(m);
                m.capture = Piece.empty;
                break;
            }
            else
                break;
        }
        else
            break;
    }

    for (i = 1; i < 8; i++)
    {
        if (row + i < 8 && col - i > -1)
        {
            if (sb.pieces[row+i][col-i] == Piece.empty)
            {
                m.to.row = row + i;
                m.to.col = col - i;
                synchronized (ml.lock)
                    ml.insertBack(m);
                continue;
            }
            else if (sb.pieces[row+i][col-i] > Piece.king)
            {
                m.to.row = row + i;
                m.to.col = col - i;
                m.capture = sb.pieces[row+i][col-i];
                synchronized (ml.lock)
                    ml.insertBack(m);
                m.capture = Piece.empty;
                break;
            }
            else
                break;
        }
        else
            break;
    }

    for (i = 1; i < 8; i++)
    {
        if (row - i > -1 && col + i < 8)
        {
            if (sb.pieces[row-i][col+i] == Piece.empty)
            {
                m.to.row = row - i;
                m.to.col = col + i;
                synchronized (ml.lock)
                    ml.insertBack(m);
                continue;
            }
            else if (sb.pieces[row-i][col+i] > Piece.king)
            {
                m.to.row = row - i;
                m.to.col = col + i;
                m.capture = sb.pieces[row-i][col+i];
                synchronized (ml.lock)
                    ml.insertBack(m);
                m.capture = Piece.empty;
                break;
            }
            else
                break;
        }
        else
            break;
    }

    for (i = 1; i < 8; i++)
    {
        if (row - i > -1 && col - i > -1)
        {
            if (sb.pieces[row-i][col-i] == Piece.empty)
            {
                m.to.row = row - i;
                m.to.col = col - i;
                synchronized (ml.lock)
                    ml.insertBack(m);
                continue;
            }
            else if (sb.pieces[row-i][col-i] > Piece.king)
            {
                m.to.row = row - i;
                m.to.col = col - i;
                m.capture = sb.pieces[row-i][col-i];
                synchronized (ml.lock)
                    ml.insertBack(m);
                m.capture = Piece.empty;
                break;
            }
            else
                break;
        }
        else
            break;
    }
}

void whiteBishopGen(immutable SimpleBoard sb, ref MoveList ml, int row, int col)
{
    int i = void;

    Move m;
    m.from.row = row;
    m.from.col = col;

    m.piece = sb.pieces[row][col];
    m.capture = Piece.empty;

    for (i = 1; i < 8; i++)
    {
        if (row + i < 8 && col + i < 8)
        {
            if (sb.pieces[row+i][col+i] == Piece.empty)
            {
                m.to.row = row + i;
                m.to.col = col + i;
                synchronized (ml.lock)
                    ml.insertBack(m);
                continue;
            }
            else if (sb.pieces[row+i][col+i] < Piece.Pawn)
            {
                m.to.row = row + i;
                m.to.col = col + i;
                m.capture = sb.pieces[row+i][col+i];
                synchronized (ml.lock)
                    ml.insertBack(m);
                m.capture = Piece.empty;
                break;
            }
            else
                break;
        }
        else
            break;
    }

    for (i = 1; i < 8; i++)
    {
        if (row + i < 8 && col - i > -1)
        {
            if (sb.pieces[row+i][col-i] == Piece.empty)
            {
                m.to.row = row + i;
                m.to.col = col - i;
                synchronized (ml.lock)
                    ml.insertBack(m);
                continue;
            }
            else if (sb.pieces[row+i][col-i] < Piece.Pawn)
            {
                m.to.row = row + i;
                m.to.col = col - i;
                m.capture = sb.pieces[row+i][col-i];
                synchronized (ml.lock)
                    ml.insertBack(m);
                m.capture = Piece.empty;
                break;
            }
            else
                break;
        }
        else
            break;
    }

    for (i = 1; i < 8; i++)
    {
        if (row - i > -1 && col + i < 8)
        {
            if (sb.pieces[row-i][col+i] == Piece.empty)
            {
                m.to.row = row - i;
                m.to.col = col + i;
                synchronized (ml.lock)
                    ml.insertBack(m);
                continue;
            }
            else if (sb.pieces[row-i][col+i] < Piece.Pawn)
            {
                m.to.row = row - i;
                m.to.col = col + i;
                m.capture = sb.pieces[row-i][col+i];
                synchronized (ml.lock)
                    ml.insertBack(m);
                m.capture = Piece.empty;
                break;
            }
            else
                break;
        }
        else
            break;
    }

    for (i = 1; i < 8; i++)
    {
        if (row - i > -1 && col - i > -1)
        {
            if (sb.pieces[row-i][col-i] == Piece.empty)
            {
                m.to.row = row - i;
                m.to.col = col - i;
                synchronized (ml.lock)
                    ml.insertBack(m);
                continue;
            }
            else if (sb.pieces[row-i][col-i] < Piece.Pawn)
            {
                m.to.row = row - i;
                m.to.col = col - i;
                m.capture = sb.pieces[row-i][col-i];
                synchronized (ml.lock)
                    ml.insertBack(m);
                m.capture = Piece.empty;
                break;
            }
            else
                break;
        }
        else
            break;
    }
}
