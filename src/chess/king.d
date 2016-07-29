module chess.king;

import chess.defs;
import chess.move;
import chess.movelist;
import chess.position;
import chess.simpleboard;
import chess.sqattack;

import core.sync.mutex;

void blackKingGen(immutable SimpleBoard sb, ref MoveList ml, int row, int col)
{
    Move m;

    m.from.row = row;
    m.from.col = col;

    m.piece = Piece.king;
    m.capture = Piece.empty;

    if (row + 1 < 8 && (sb.pieces[row+1][col] == Piece.empty || sb.pieces[row+1][col] > Piece.king))
    {
        m.to.row = row + 1;
        m.to.col = col;
        m.capture = sb.pieces[row+1][col];
        synchronized (ml.lock)
            ml.insertBack(m);
    }

    if (row - 1 > -1 && (sb.pieces[row-1][col] == Piece.empty || sb.pieces[row-1][col] > Piece.king))
    {
        m.to.row = row - 1;
        m.to.col = col;
        m.capture = sb.pieces[row+1][col];
        synchronized (ml.lock)
            ml.insertBack(m);
    }

    if (col + 1 < 8 && (sb.pieces[row][col+1] == Piece.empty || sb.pieces[row][col+1] > Piece.king))
    {
        m.to.row = row;
        m.to.col = col + 1;
        m.capture = sb.pieces[row][col+1];
        synchronized (ml.lock)
            ml.insertBack(m);
    }

    if (col - 1 > -1 && (sb.pieces[row][col-1] == Piece.empty || sb.pieces[row][col-1] > Piece.king))
    {
        m.to.row = row;
        m.to.col = col - 1;
        m.capture = sb.pieces[row][col+1];
        synchronized (ml.lock)
            ml.insertBack(m);
    }

    if (sb.castlePerm & Castle.king && sb.pieces[0][6] == Piece.empty && sb.pieces[0][5] == Piece.empty)
    {
        if (!(squareAttacked(Position(0,5), sb, WHITE) || squareAttacked(Position(0,6), sb, WHITE)))
        {
            m.to.row = 0;
            m.to.col = 6;
            m.castle = Castle.king;
            synchronized (ml.lock)
                ml.insertBack(m);
        }
    }

    if (sb.castlePerm & Castle.queen && sb.pieces[0][1] == Piece.empty && sb.pieces[0][2] == Piece.empty && sb.pieces[0][3] == Piece.empty)
    {
        if (!(squareAttacked(Position(0,1), sb, WHITE) || squareAttacked(Position(0,2), sb, WHITE) || squareAttacked(Position(0,3), sb, WHITE)))
        {
            m.to.row = 0;
            m.to.col = 2;
            m.castle = Castle.queen;
            synchronized (ml.lock)
                ml.insertBack(m);
        }
    }
}

void whiteKingGen(immutable SimpleBoard sb, ref MoveList ml, int row, int col)
{
    Move m;

    m.from.row = row;
    m.from.col = col;

    m.piece = Piece.King;
    m.capture = Piece.empty;

    if (row + 1 < 8 && sb.pieces[row+1][col] > Piece.king)
    {
        m.to.row = row + 1;
        m.to.col = col;
        m.capture = sb.pieces[row+1][col];
        synchronized (ml.lock)
            ml.insertBack(m);
    }

    if (row - 1 > -1 && sb.pieces[row-1][col] > Piece.king)
    {
        m.to.row = row - 1;
        m.to.col = col;
        m.capture = sb.pieces[row+1][col];
        synchronized (ml.lock)
            ml.insertBack(m);
    }

    if (col + 1 < 8 && sb.pieces[row][col+1] > Piece.king)
    {
        m.to.row = row;
        m.to.col = col + 1;
        m.capture = sb.pieces[row][col+1];
        synchronized (ml.lock)
            ml.insertBack(m);
    }

    if (col - 1 > -1 && sb.pieces[row][col+1] > Piece.king)
    {
        m.to.row = row;
        m.to.col = col - 1;
        m.capture = sb.pieces[row][col+1];
        synchronized (ml.lock)
            ml.insertBack(m);
    }

    if (sb.castlePerm & Castle.King && sb.pieces[7][6] == Piece.empty && sb.pieces[7][5] == Piece.empty)
    {
        if (!(squareAttacked(Position(7,5), sb, BLACK) || squareAttacked(Position(7,6), sb, BLACK)))
        {
            m.to.row = 7;
            m.to.col = 6;
            m.castle = Castle.King;
            synchronized (ml.lock)
                ml.insertBack(m);
        }
    }

    if (sb.castlePerm & Castle.Queen && sb.pieces[7][1] == Piece.empty && sb.pieces[7][2] == Piece.empty && sb.pieces[7][3] == Piece.empty)
    {
        if (!(squareAttacked(Position(7,1), sb, WHITE) || squareAttacked(Position(7,2), sb, WHITE) || squareAttacked(Position(7,3), sb, WHITE)))
        {
            m.to.row = 7;
            m.to.col = 2;
            m.castle = Castle.Queen;
            synchronized (ml.lock)
                ml.insertBack(m);
        }
    }
}
