module player.player;

import chess.board;
import chess.move;

interface Player
{
    void updateBoard(const Board);
    Move getMove();
}
