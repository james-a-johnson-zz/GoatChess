module player.human;

import player.player;

import chess.board;
import chess.defs;
import chess.move;

import std.stdio;

class Human : Player
{
    void updateBoard(const Board b)
    {
        b.print();
    }

    Move getMove()
    {
        Move m;
        char[] input;

        write("Enter move in algebraic notation: ");
        readln(input);

        m.from.row = (8 - (input[1] - '0'));
        m.from.col = (input[0] - 'a');
        m.to.row = (8 - (input[3] - '0'));
        m.to.col = (input[2] - 'a');

        try
        {
            switch (input[4])
            {
                case 'q':
                    m.promotion = Piece.queen;
                    break;
                case 'r':
                    m.promotion = Piece.rook;
                    break;
                case 'b':
                    m.promotion = Piece.bishop;
                    break;
                case 'n':
                    m.promotion = Piece.knight;
                    break;
                case 'Q':
                    m.promotion = Piece.Queen;
                    break;
                case 'R':
                    m.promotion = Piece.Rook;
                    break;
                case 'B':
                    m.promotion = Piece.Bishop;
                    break;
                case 'N':
                    m.promotion = Piece.Knight;
                    break;
                default:
                    m.promotion = Piece.empty;
            }
        }
        catch (Exception e)
        {
        }

        return m;
    }
}
