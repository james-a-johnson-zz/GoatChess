module player.human;

import player.player;

import chess.board;
import chess.move;

class Human : Player
{
    void updateBoard(const Board b)
    {
        b.print();
    }

    Move getMove()
    {
        Move m;

        return m;
    }
}
