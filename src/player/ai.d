module player.AI;

import player.player;
import player.pvtable;

import chess.board;
import chess.move;

class AI : Player
{
private:
    Board board;
    PVTable pvtable;

public:
    this()
    {
        pvtable = new PVTable(131070);
    }

    void updateBoard(const Board b)
    {
        board = b.dup();
    }

    Move getMove()
    {
        Move m;

        return m;
    }
}
