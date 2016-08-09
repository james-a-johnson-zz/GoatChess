module game;

import chess.board;
import chess.move;
import chess.movegen;
import chess.movelist;

import player.player;
import player.human;
import player.ai;

import std.stdio;

class Game
{
    Board b;
    Player white;
    Player black;

    this()
    {
        b = new Board();

        white = new AI();
        black = new AI();
    }

    void play()
    {
        /*
        MoveList ml;
        Move m;
        bool valid;
        while (true)
        {
            white.updateBoard(b);
            ml = genMoves(b.SB);
            valid = false;

            do
            {
                m = white.getMove();
                foreach (move; ml.moves)
                {
                    if (move.from == m.from && move.to == m.to)
                    {
                        m = move;
                        valid = true;
                        break;
                    }
                }
            } while (!valid);

            b.makeMove(m);

            black.updateBoard(b);
            ml = genMoves(b.SB);
            valid = false;

            do
            {
                m = black.getMove();
                foreach (move; ml.moves)
                {
                    if (move.from == m.from && move.to == m.to)
                    {
                        m = move;
                        valid = true;
                        break;
                    }
                }
            } while (!valid);

            b.makeMove(m);
        }
        */

        b.print();
        white.updateBoard(b);
        white.getMove();
    }
}
