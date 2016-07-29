module chess.movegen;

import chess.board;
import chess.defs;
import chess.move;
import chess.movelist;
import chess.position;
import chess.simpleboard;
import chess.sqattack;

import chess.bishop;
import chess.king;
import chess.knight;
import chess.pawn;
import chess.rook;
import chess.queen;

import core.sync.mutex;
import std.container : Array;
import std.parallelism;

MoveList genMoves(SimpleBoard sb)
{
    MoveList ml;
    ml.lock = new Mutex;
    Position[] moves;
    Position king;

    for (int i = 0; i < 8; i++)
    {
        for (int j = 0; j < 8; j++)
        {
            if (sb.turn)
            {
                switch (sb.pieces[i][j])
                {
                    case Piece.empty:
                        continue;
                    case Piece.pawn:
                    case Piece.rook:
                    case Piece.knight:
                    case Piece.bishop:
                    case Piece.queen:
                    case Piece.king:
                        moves ~= Position(i, j);
                        break;
                    default:
                        break;
                }
            }
            else
            {
                switch (sb.pieces[i][j])
                {
                    case Piece.empty:
                        continue;
                    case Piece.Pawn:
                    case Piece.Rook:
                    case Piece.Knight:
                    case Piece.Bishop:
                    case Piece.Queen:
                    case Piece.King:
                        moves ~= Position(i, j);
                        break;
                    default:
                        break;
                }
            }
        }
    }

    foreach (move; parallel(moves, 4))
    {
        switch (sb.pieces[move.row][move.col])
        {
            case Piece.pawn:
                blackPawnGen(sb, ml, move.row, move.col);
                break;
            case Piece.rook:
                blackRookGen(sb, ml, move.row, move.col);
                break;
            case Piece.knight:
                blackKnightGen(sb, ml, move.row, move.col);
                break;
            case Piece.bishop:
                blackBishopGen(sb, ml, move.row, move.col);
                break;
            case Piece.queen:
                blackQueenGen(sb, ml, move.row, move.col);
                break;
            case Piece.king:
                king.row = move.row;
                king.col = move.col;
                blackKingGen(sb, ml, move.row, move.col);
                break;
            case Piece.Pawn:
                whitePawnGen(sb, ml, move.row, move.col);
                break;
            case Piece.Rook:
                whiteRookGen(sb, ml, move.row, move.col);
                break;
            case Piece.Knight:
                whiteKnightGen(sb, ml, move.row, move.col);
                break;
            case Piece.Bishop:
                whiteBishopGen(sb, ml, move.row, move.col);
                break;
            case Piece.Queen:
                whiteQueenGen(sb, ml, move.row, move.col);
                break;
            case Piece.King:
                king.row = move.row;
                king.col = move.col;
                whiteKingGen(sb, ml, move.row, move.col);
                break;
            default:
                break;
        }
    }

    MoveList mlFinal;

    foreach (move; ml.moves)
    {
        if (move.castle != 0)
            continue;
        sb.pieces[move.to.row][move.to.col] = move.piece;
        sb.pieces[move.from.row][move.from.col] = Piece.empty;

        if (!squareAttacked(king, sb, !sb.turn))
                mlFinal.insert(move);

        sb.pieces[move.from.row][move.from.col] = move.piece;
        sb.pieces[move.to.row][move.to.col] = move.capture;
    }

    return mlFinal;
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
