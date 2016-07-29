module chess.sqattack;

import chess.defs;
import chess.position;
import chess.simpleboard;

/*
   This function tests to see if a square can be attacked
   by one side or the other.
   It will go through every piece because I'm lazy and
   can't think of anything better.
 */
bool squareAttacked(Position p, SimpleBoard sb, bool side)
{
    int row = p.row;
    int col = p.col;
    Piece piece1;
    Piece piece2;

    // Check Pawns
    // These have to be entirely split because it changes movement.
    if (side)
    {
        if (row - 1 > -1)
        {
            if (col + 1 < 8 && sb.pieces[row-1][col+1] == Piece.pawn)
                return true;
            if (col -1 > -1 && sb.pieces[row-1][col-1] == Piece.pawn)
                return true;
        }
    }
    else
    {
        if (row + 1 < 8)
        {
            if (col + 1 < 8 && sb.pieces[row+1][col+1] == Piece.Pawn)
                return true;
            if (col - 1 > -1 && sb.pieces[row+1][col-1] == Piece.Pawn)
                return true;
        }
    }

    // Check rooks
    if (side)
    {
        piece1 = Piece.rook;
        piece2 = Piece.queen;
    }
    else
    {
        piece1 = Piece.Rook;
        piece2 = Piece.Queen;
    }

    for (int i = 1; i < 8; i++)
    {
        if (row + i == 8)
            break;
        else if (sb.pieces[row+i][col] == Piece.empty)
            continue;
        else if (sb.pieces[row+i][col] == piece1 || sb.pieces[row+i][col] == piece2)
            return true;
        else
            break;
    }

    for (int i = 1; i < 8; i++)
    {
        if (row - i == -1)
            break;
        else if (sb.pieces[row-i][col] == Piece.empty)
            continue;
        else if (sb.pieces[row-i][col] == piece1 || sb.pieces[row-i][col] == piece2)
            return true;
        else
            break;
    }

    for (int i = 1; i < 8; i++)
    {
        if (col + i == 8)
            break;
        else if (sb.pieces[row][col+i] == Piece.empty)
            continue;
        else if (sb.pieces[row][col+i] == piece1 || sb.pieces[row][col+i] == piece2)
            return true;
        else
            break;
    }

    for (int i = 1; i < 8; i++)
    {
        if (col - i == -1)
            break;
        else if (sb.pieces[row][col-i] == Piece.empty)
            continue;
        else if (sb.pieces[row][col-i] == piece1 || sb.pieces[row][col-i] == piece2)
            return true;
        else
            break;
    }

    // check bishops
    if (side)
    {
        piece1 = Piece.bishop;
        piece2 = Piece.queen;
    }
    else
    {
        piece1 = Piece.Bishop;
        piece2 = Piece.Queen;
    }

    for (int i = 1; i < 8; i++)
    {
        if (row + i == 8 || col + i == 8)
            break;
        else if (sb.pieces[row+i][col+i] == Piece.empty)
            continue;
        else if (sb.pieces[row+i][col+i] == piece1 || sb.pieces[row+i][col+i] == piece2)
            return true;
        else
            break;
    }

    for (int i = 1; i < 8; i++)
    {
        if (row + i == 8 || col - i == -1)
            break;
        else if (sb.pieces[row+i][col-i] == Piece.empty)
            continue;
        else if (sb.pieces[row+i][col-i] == piece1 || sb.pieces[row+i][col-i] == piece2)
            return true;
        else
            break;
    }

    for (int i = 1; i < 8; i++)
    {
        if (row - i == -1 || col + i == 8)
            break;
        else if (sb.pieces[row-i][col+i] == Piece.empty)
            continue;
        else if (sb.pieces[row-i][col+i] == piece1 || sb.pieces[row-i][col+i] == piece2)
            return true;
        else
            break;
    }

    for (int i = 1; i < 8; i++)
    {
        if (row - i == -1 || col - i == -1)
            break;
        else if (sb.pieces[row-i][col-i] == Piece.empty)
            continue;
        else if (sb.pieces[row-i][col-i] == piece1 || sb.pieces[row-i][col-i] == piece2)
            return true;
        else
            break;
    }

    // Check for knights.
    if (side)
        piece1 = Piece.knight;
    else
        piece1 = Piece.Knight;

    if (row + 2 < 8 && col + 1 < 8 && sb.pieces[row+2][col+1] == piece1)
        return true;
    if (row + 1 < 8 && col + 2 < 8 && sb.pieces[row+1][col+2] == piece1)
        return true;
    if (row + 2 < 8 && col - 1 > -1 && sb.pieces[row+2][col-1] == piece1)
        return true;
    if (row + 1 < 8 && col - 2 > -1 && sb.pieces[row+1][col+2] == piece1)
        return true;
    if (row - 2 > -1 && col + 1 < 8 && sb.pieces[row-2][col+1] == piece1)
        return true;
    if (row - 1 > -1 && col + 2 < 8 && sb.pieces[row-1][col+2] == piece1)
        return true;
    if (row - 2 > -1 && col - 1 > -1 && sb.pieces[row+2][col+1] == piece1)
        return true;
    if (row - 1 > -1 && col - 2 > -1 && sb.pieces[row+1][col+2] == piece1)
        return true;

    if (side)
        piece1 = Piece.king;
    else
        piece1 = Piece.King;

    if (row + 1 < 8 && sb.pieces[row+1][col] == piece1)
        return true;
    if (row - 1 > -1 && sb.pieces[row-1][col] == piece1)
        return true;
    if (col + 1 < 8 && sb.pieces[row][col+1] == piece1)
        return true;
    if (col - 1 > -1 && sb.pieces[row][col-1] == piece1)
        return true;
    if (row + 1 < 8 && col + 1 < 8 && sb.pieces[row+1][col+1] == piece1)
        return true;
    if (row + 1 < 8 && col - 1 > -1 && sb.pieces[row+1][col-1] == piece1)
        return true;
    if (row - 1 > -1 && col + 1 < 8 && sb.pieces[row-1][col+1] == piece1)
        return true;
    if (row - 1 > -1 && col - 1 > -1 && sb.pieces[row-1][col-1] == piece1)
        return true;

    return false;
}
