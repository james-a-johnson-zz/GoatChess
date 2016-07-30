module game;

import chess.board;

import player.player;
import player.human;

class Game
{
    Board b;
    Player white;
    Player black;

    this()
    {
        b = new Board();

        white = new Human();
        black = new Human();
    }

    void play()
    {
        white.updateBoard(b);
    }
}
