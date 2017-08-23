module player.AI;

import player.player;

import chess.board;
import chess.defs;
import chess.move;
import chess.movegen;
import chess.movelist;
import chess.position;
import chess.sqattack;

import std.stdio;

immutable Move emptyMove = Move(Piece.empty, Piece.empty, Piece.empty, Position(-1, -1), Position(-1, -1), Position(-1, -1), 0);

immutable int mate = 100000;
immutable int inf = int.max;

immutable int[13] material = [ 0, -10, -30, -35, -50, -90, 0, 10, 30, 35, 50, 90, 0 ];

immutable int[8][8] PawnTable = [
    [  0,  0,  0,   0,   0,  0,  0,  0 ],
    [ 10, 10,  0, -10, -10,  0, 10, 10 ],
    [  5,  0,  0,   5,   5,  0,  0,  5 ],
    [  0,  0, 10,  20,  20, 10,  0,  0 ],
    [  5,  5,  5,  10,  10,  5,  5,  5 ],
    [ 10, 10, 10,  20,  20, 10, 10, 10 ],
    [  0,  0,  0,   0,   0,  0,  0,  0 ]
    ];

immutable int[8][8] KnightTable = [
    [ 0, -10,  0,  0,  0,  0, -10, 0 ],
    [ 0,   0,  0,  5,  5,  0,   0, 0 ],
    [ 0,   0, 10, 10, 10, 10,   0, 0 ],
    [ 0,   0, 10, 20, 20, 10,   5, 0 ],
    [ 5,  10, 15, 20, 20, 15,  10, 5 ],
    [ 0,   0,  5, 10, 10,  5,   0, 0 ],
    [ 0,   0,  0,  0,  0,  0,   0, 0 ]
    ];

immutable int[8][8] BishopTable = [
    [ 0,  0, -10,  0,  0, -10,  0, 0 ],
    [ 0,  0,   0, 10, 10,   0,  0, 0 ],
    [ 0,  0,  10, 15, 15,  10,  0, 0 ],
    [ 0, 10,  15, 20, 20,  15, 10, 0 ],
    [ 0, 10,  15, 20, 20,  15, 10, 0 ],
    [ 0,  0,  10, 15, 15,  10,  0, 0 ],
    [ 0,  0,   0, 10, 10,   0,  0, 0 ],
    [ 0,  0,   0,  0,  0,   0,  0, 0 ]
    ];

immutable int[8][8] RookTable = [
    [  0,  0,  5, 10, 10,  5,  0,  0 ],
    [  0,  0,  5, 10, 10,  5,  0,  0 ],
    [  0,  0,  5, 10, 10,  5,  0,  0 ],
    [  0,  0,  5, 10, 10,  5,  0,  0 ],
    [  0,  0,  5, 10, 10,  5,  0,  0 ],
    [  0,  0,  5, 10, 10,  5,  0,  0 ],
    [ 25, 25, 25, 25, 25, 25, 25, 25 ],
    [  0,  0,  5, 10, 10,  5,  0,  0 ],
    ];

class AI : Player
{
private:
    Board board;

    Position wKing;
    Position bKing;

    int ply;
    uint nodes;

    MonoTime start;

    float fh;
    float fhf;

    Move bMove;

public:
    this()
    {
    }

    void updateBoard(const Board b)
    {
        board = b.dup();
        for (int i = 0; i < 8; i++)
        {
            for (int j = 0; j < 8; j++)
            {
                if (board[i, j] == Piece.King)
                    wKing = Position(i, j);
                if (board[i, j] == Piece.king)
                    bKing = Position(i, j);
            }
        }
    }

    Move getMove()
    {
        searchPosition();

        return bMove;
    }

    bool validMove(Move m) const
    {
        MoveList ml = genMoves(board.SB);

        foreach (move; ml.moves)
        {
            if (m == move)
                return true;
        }

        return false;
    }

    int evalPosition() const
    {
        int score;
        for (int i = 0; i < 8; i++)
        {
            for (int j = 0; j < 8; j++)
            {
                score += material[board[i][j]];
            }
        }
        return score;
    }

    void searchPosition()
    {
    }

    int alphaBeta(int alpha, int beta, int depth)
    {
    }
}
