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

MoveList genMoves(immutable SimpleBoard sb)
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

private
{
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
        ml.insert(m);

        if (row == 1 && sb.pieces[3][col] == Piece.empty)
        {
            m.to.row = 3;
            m.to.col = col;
            m.enPas.row = 2;
            m.enPas.col = col;
            ml.insert(m);
            m.enPas.row = -1;
            m.enPas.col = -1;
        }
    }

    if (col - 1 > -1 && sb.pieces[row+1][col-1] > Piece.king)
    {
        m.to.row = row + 1;
        m.to.col = col - 1;
        m.capture = sb.pieces[row+1][col-1];
        ml.insert(m);
        m.capture = Piece.empty;
    }

    if (col + 1 < 9 && sb.pieces[row+1][col+1] > Piece.king)
    {
        m.to.row = row + 1;
        m.to.col = col + 1;
        m.capture = sb.pieces[row+1][col+1];
        ml.insert(m);
        m.capture = Piece.empty;
    }

    if ((row + 1 == sb.enPas.row) && (col - 1 == sb.enPas.col || col + 1 == sb.enPas.col))
    {
        m.to.row = sb.enPas.row;
        m.to.col = sb.enPas.col;
        ml.insert(m);
    }
}

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
        ml.insert(m);
    }

    if (row + 2 < 8 && col + 1 < 8 && (sb.pieces[row+2][col+1] > Piece.king || sb.pieces[row+2][col+1] == Piece.empty))
    {
        m.to.row = row + 2;
        m.to.col = col + 1;
        m.capture = sb.pieces[row+2][col+1];
        ml.insert(m);
    }

    if (row - 2 > -1 && col + 1 < 8 && (sb.pieces[row-2][col+1] > Piece.king || sb.pieces[row-2][col+1] == Piece.empty))
    {
        m.to.row = row - 2;
        m.to.col = col + 1;
        m.capture = sb.pieces[row-2][col+1];
        ml.insert(m);
    }

    if (row - 1 > -1 && col + 2 < 8 && (sb.pieces[row-1][col+2] > Piece.king || sb.pieces[row-1][col+2] == Piece.empty))
    {
        m.to.row = row - 1;
        m.to.col = col + 2;
        m.capture = sb.pieces[row-1][col+2];
        ml.insert(m);
    }

    if (row - 1 > -1 && col - 2 > -1 && (sb.pieces[row-1][col-2] > Piece.king || sb.pieces[row-1][col-2] == Piece.empty))
    {
        m.to.row = row - 1;
        m.to.col = col - 2;
        m.capture = sb.pieces[row-1][col-2];
        ml.insert(m);
    }

    if (row - 2 > -1 && col - 1 > -1 && (sb.pieces[row-2][col-1] > Piece.king || sb.pieces[row-2][col-1] == Piece.empty))
    {
        m.to.row = row - 2;
        m.to.col = col - 1;
        m.capture = sb.pieces[row-2][col-1];
        ml.insert(m);
    }

    if (row + 2 < 8 && col - 1 > -1 && (sb.pieces[row+2][col-1] > Piece.king || sb.pieces[row+2][col-1] == Piece.empty))
    {
        m.to.row = row + 2;
        m.to.col = col - 1;
        m.capture = sb.pieces[row+2][col-1];
        ml.insert(m);
    }

    if (row + 1 < 8 && col - 2 > -1 && (sb.pieces[row+1][col-2] > Piece.king || sb.pieces[row+1][col-2] == Piece.empty))
    {
        m.to.row = row + 1;
        m.to.col = col - 2;
        m.capture = sb.pieces[row+1][col-2];
        ml.insert(m);
        m.capture = Piece.empty;
    }
}

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
                ml.insert(m);
                continue;
            }
            else if (sb.pieces[row+i][col+i] > Piece.king)
            {
                m.to.row = row + i;
                m.to.col = col + i;
                m.capture = sb.pieces[row+i][col+i];
                ml.insert(m);
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
                ml.insert(m);
                continue;
            }
            else if (sb.pieces[row+i][col-i] > Piece.king)
            {
                m.to.row = row + i;
                m.to.col = col - i;
                m.capture = sb.pieces[row+i][col-i];
                ml.insert(m);
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
                ml.insert(m);
                continue;
            }
            else if (sb.pieces[row-i][col+i] > Piece.king)
            {
                m.to.row = row - i;
                m.to.col = col + i;
                m.capture = sb.pieces[row-i][col+i];
                ml.insert(m);
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
                ml.insert(m);
                continue;
            }
            else if (sb.pieces[row-i][col-i] > Piece.king)
            {
                m.to.row = row - i;
                m.to.col = col - i;
                m.capture = sb.pieces[row-i][col-i];
                ml.insert(m);
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

void blackRookGen(immutable SimpleBoard sb, ref MoveList ml, int row, int col)
{
    int i = void;

    Move m;
    m.from.row = row;
    m.from.col = col;

    m.piece = sb.pieces[row][col];
    m.capture = Piece.empty;

    for (i = 1; i < 8; i++)
    {
        if (row + i < 8)
        {
            if (sb.pieces[row+i][col] == Piece.empty)
            {
                m.to.row = row + i;
                m.to.col = col;
                ml.insert(m);
                continue;
            }
            else if (sb.pieces[row+i][col] > Piece.king)
            {
                m.to.row = row + i;
                m.to.col = col;
                m.capture = sb.pieces[row+i][col];
                ml.insert(m);
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
        if (col + i < 8)
        {
            if (sb.pieces[row][col+i] == Piece.empty)
            {
                m.to.row = row;
                m.to.col = col + i;
                ml.insert(m);
                continue;
            }
            else if (sb.pieces[row][col+i] > Piece.king)
            {
                m.to.row = row;
                m.to.col = col + i;
                m.capture = sb.pieces[row][col+i];
                ml.insert(m);
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
        if (row - i > -1)
        {
            if (sb.pieces[row-i][col] == Piece.empty)
            {
                m.to.row = row - i;
                m.to.col = col;
                ml.insert(m);
                continue;
            }
            else if (sb.pieces[row-i][col] > Piece.king)
            {
                m.to.row = row - i;
                m.to.col = col;
                m.capture = sb.pieces[row-i][col];
                ml.insert(m);
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
        if (col - i > -1)
        {
            if (sb.pieces[row][col-i] == Piece.empty)
            {
                m.to.row = row;
                m.to.col = col - i;
                ml.insert(m);
                continue;
            }
            else if (sb.pieces[row][col-i] > Piece.king)
            {
                m.to.row = row;
                m.to.col = col - i;
                m.capture = sb.pieces[row][col-i];
                ml.insert(m);
                break;
            }
            else
                break;
        }
        else
            break;
    }
}

void blackQueenGen(immutable SimpleBoard sb, ref MoveList ml, int row, int col)
{
    blackBishopGen(sb, ml, row, col);
    blackRookGen(sb, ml, row, col);
}

void blackKingGen(immutable SimpleBoard sb, ref MoveList ml, int row, int col)
{
}

void whitePawnGen(immutable SimpleBoard sb, ref MoveList ml, int row, int col)
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

    if (sb.pieces[row-1][col-1] == Piece.empty)
    {
        m.to.row = row - 1;
        m.to.col = col;
        ml.insert(m);

        if (row == 6 && sb.pieces[6][col-2] == Piece.empty)
        {
            m.to.row = 4;
            m.to.col = col;
            m.enPas.row = 3;
            m.enPas.col = col;
            ml.insert(m);
            m.enPas.row = -1;
            m.enPas.col = -1;
        }
    }

    if (col - 1 > -1 && sb.pieces[row-1][col-1] < Piece.Pawn && sb.pieces[row-1][col-1] != Piece.empty)
    {
        m.to.row = row - 1;
        m.to.col = col - 1;
        m.capture = sb.pieces[row-1][col-1];
        ml.insert(m);
        m.capture = Piece.empty;
    }

    if (col + 1 < 9 && sb.pieces[row-1][col+1] < Piece.Pawn && sb.pieces[row-1][col+1] != Piece.empty)
    {
        m.to.row = row - 1;
        m.to.col = col + 1;
        m.capture = sb.pieces[row-1][col+1];
        ml.insert(m);
        m.capture = Piece.empty;
    }

    if ((row - 1 == sb.enPas.row) && (col - 1 == sb.enPas.col && col + 1 == sb.enPas.col))
    {
        m.to.row = sb.enPas.row;
        m.to.col = sb.enPas.col;
        ml.insert(m);
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
        ml.insert(m);
    }

    if (row + 2 < 8 && col + 1 < 8 && sb.pieces[row+2][col+1] < Piece.Pawn)
    {
        m.to.row = row + 2;
        m.to.col = col + 1;
        m.capture = sb.pieces[row+2][col+1];
        ml.insert(m);
    }

    if (row - 2 > -1 && col + 1 < 8 && sb.pieces[row-2][col+1] < Piece.Pawn)
    {
        m.to.row = row - 2;
        m.to.col = col + 1;
        m.capture = sb.pieces[row-2][col+1];
        ml.insert(m);
    }

    if (row - 1 > -1 && col + 2 < 8 && sb.pieces[row-1][col+2] < Piece.Pawn)
    {
        m.to.row = row - 1;
        m.to.col = col + 2;
        m.capture = sb.pieces[row-1][col+2];
        ml.insert(m);
    }

    if (row - 1 > -1 && col - 2 > -1 && sb.pieces[row-1][col-2] < Piece.Pawn)
    {
        m.to.row = row - 1;
        m.to.col = col - 2;
        m.capture = sb.pieces[row-1][col-2];
        ml.insert(m);
    }

    if (row - 2 > -1 && col - 1 > -1 && sb.pieces[row-2][col-1] < Piece.Pawn)
    {
        m.to.row = row - 2;
        m.to.col = col - 1;
        m.capture = sb.pieces[row-2][col-1];
        ml.insert(m);
    }

    if (row + 2 < 8 && col - 1 > -1 && sb.pieces[row+2][col-1] < Piece.Pawn)
    {
        m.to.row = row + 2;
        m.to.col = col - 1;
        m.capture = sb.pieces[row+2][col-1];
        ml.insert(m);
    }

    if (row + 1 < 8 && col - 2 > -1 && sb.pieces[row+1][col-2] < Piece.Pawn)
    {
        m.to.row = row + 1;
        m.to.col = col - 2;
        m.capture = sb.pieces[row+1][col-2];
        ml.insert(m);
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
                ml.insert(m);
                continue;
            }
            else if (sb.pieces[row+i][col+i] < Piece.Pawn)
            {
                m.to.row = row + i;
                m.to.col = col + i;
                m.capture = sb.pieces[row+i][col+i];
                ml.insert(m);
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
                ml.insert(m);
                continue;
            }
            else if (sb.pieces[row+i][col-i] < Piece.Pawn)
            {
                m.to.row = row + i;
                m.to.col = col - i;
                m.capture = sb.pieces[row+i][col-i];
                ml.insert(m);
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
                ml.insert(m);
                continue;
            }
            else if (sb.pieces[row-i][col+i] < Piece.Pawn)
            {
                m.to.row = row - i;
                m.to.col = col + i;
                m.capture = sb.pieces[row-i][col+i];
                ml.insert(m);
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
                ml.insert(m);
                continue;
            }
            else if (sb.pieces[row-i][col-i] < Piece.Pawn)
            {
                m.to.row = row - i;
                m.to.col = col - i;
                m.capture = sb.pieces[row-i][col-i];
                ml.insert(m);
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

void whiteRookGen(immutable SimpleBoard sb, ref MoveList ml, int row, int col)
{
    int i = void;

    Move m;
    m.from.row = row;
    m.from.col = col;

    m.piece = sb.pieces[row][col];
    m.capture = Piece.empty;

    for (i = 1; i < 8; i++)
    {
        if (row + i < 8)
        {
            if (sb.pieces[row+i][col] == Piece.empty)
            {
                m.to.row = row + i;
                m.to.col = col;
                ml.insert(m);
                continue;
            }
            else if (sb.pieces[row+i][col] < Piece.Pawn)
            {
                m.to.row = row + i;
                m.to.col = col;
                m.capture = sb.pieces[row+i][col];
                ml.insert(m);
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
        if (col + i < 8)
        {
            if (sb.pieces[row][col+i] == Piece.empty)
            {
                m.to.row = row;
                m.to.col = col + i;
                ml.insert(m);
                continue;
            }
            else if (sb.pieces[row][col+i] < Piece.Pawn)
            {
                m.to.row = row;
                m.to.col = col + i;
                m.capture = sb.pieces[row][col+i];
                ml.insert(m);
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
        if (row - i > -1)
        {
            if (sb.pieces[row-i][col] == Piece.empty)
            {
                m.to.row = row - i;
                m.to.col = col;
                ml.insert(m);
                continue;
            }
            else if (sb.pieces[row-i][col] < Piece.Pawn)
            {
                m.to.row = row - i;
                m.to.col = col;
                m.capture = sb.pieces[row-i][col];
                ml.insert(m);
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
        if (col - i > -1)
        {
            if (sb.pieces[row][col-i] == Piece.empty)
            {
                m.to.row = row;
                m.to.col = col - i;
                ml.insert(m);
                continue;
            }
            else if (sb.pieces[row][col-i] < Piece.Pawn)
            {
                m.to.row = row;
                m.to.col = col - i;
                m.capture = sb.pieces[row][col-i];
                ml.insert(m);
                break;
            }
            else
                break;
        }
        else
            break;
    }
}

void whiteQueenGen(immutable SimpleBoard sb, ref MoveList ml, int row, int col)
{
    whiteBishopGen(sb, ml, row, col);
    whiteRookGen(sb, ml, row, col);
}

void whiteKingGen(immutable SimpleBoard sb, ref MoveList ml, int row, int col)
{
}

// TODO(jjohnson): Implement this.
bool squareAttacked(Position p, SimpleBoard sb, bool side)
{
debug
{
    return true;
}
}
}

/* TESTING */
unittest
{
    SimpleBoard sb;
    sb.pieces[1][2] = Piece.pawn;
    sb.pieces[7][7] = Piece.knight;
    sb.pieces[0][0] = Piece.queen;
    sb.castlePerm = 0b1111;
    sb.enPas.row = -1;
    sb.enPas.col = -1;
    sb.turn = BLACK;

    MoveList moves = genMoves(sb);

    assert(moves.length == 24);

    sb.pieces[2][3] = Piece.Rook;
    sb.pieces[0][0] = Piece.empty;
    sb.enPas.row = 2;
    sb.enPas.col = 1;

    moves = genMoves(sb);

    assert(moves.length == 6);


    sb.pieces[1][2] = Piece.empty;
    sb.pieces[7][7] = Piece.empty;
    sb.pieces[2][3] = Piece.rook;
    sb.pieces[0][0] = Piece.Knight;
    sb.enPas.row = -1;
    sb.enPas.col = -1;

    sb.pieces[6][2] = Piece.Pawn;
    sb.turn = WHITE;

    moves = genMoves(sb);

    assert(moves.length == 4);
}
