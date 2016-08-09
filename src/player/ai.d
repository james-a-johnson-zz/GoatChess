module player.AI;

import player.player;

import chess.board;
import chess.defs;
import chess.move;
import chess.movegen;
import chess.movelist;
import chess.position;
import chess.sqattack;

import core.time;

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
    Move[64] PVarray;

    Move[13][8][8] searchHistory;
    Move[64][2] searchKillers;

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

    void reset()
    {
        for (int i = 0; i < 8; i++)
            for (int j = 0; j < 8; j++)
                for (int k = 0; k < 13; k++)
                    searchHistory[i][j][k] = emptyMove;

        for (int i = 0; i < 2; i++)
            for (int j = 0; j < 64; j++)
                searchKillers[i][j] = emptyMove;

        ply = 0;

        nodes = 0;

        start = MonoTime.currTime;

        fh = 0;
        fhf = 0;
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
        int score = 0;

        for (int i = 0; i < 8; i++)
        {
            for (int j = 0; j < 8; j++)
            {
                score += material[board[i, j]];

                switch (board[i, j])
                {
                    case Piece.empty:
                        break;
                    case Piece.pawn:
                        score -= PawnTable[i][j];
                        break;
                    case Piece.rook:
                        score -= RookTable[i][j];
                        break;
                    case Piece.knight:
                        score -= KnightTable[i][j];
                        break;
                    case Piece.bishop:
                        score -= BishopTable[i][j];
                        break;
                    case Piece.Pawn:
                        score += PawnTable[i][7-j];
                        break;
                    case Piece.Rook:
                        score += RookTable[i][7-j];
                        break;
                    case Piece.Knight:
                        score += KnightTable[i][7-j];
                        break;
                    case Piece.Bishop:
                        score += BishopTable[i][7-j];
                        break;
                    default:
                        break;
                }
            }
        }

        if (board.turn)
            return -score;
        else
            return score;
    }

    void clearPVArray()
    {
        for (int i = 0; i < 64; i++)
            PVarray[i] = emptyMove;
    }

    void searchPosition()
    {
        Move bestMove = emptyMove;
        int bestScore = -inf;
        int currentDepth = void;
        int pvNum = 0;
        reset();

        for (currentDepth = 1; currentDepth < 5; currentDepth++)
        {
            clearPVArray();

            bestScore = alphaBeta(-inf, inf, currentDepth);

            bestMove = PVarray[0];

            writef("depth:%s score:%s nodes:%s ",
                    currentDepth, bestScore, nodes);

            for (int i = 0; PVarray[i] != emptyMove; i++)
                writef(" %s", PVarray[i]);
            write("\n");
        }

        bMove = bestMove;
    }

    int quiescence(int alpha, int beta)
    {
        return 0;
    }

    int alphaBeta(int alpha, int beta, int depth)
    {
        assert(depth >= 0);
        if (depth == 0)
        {
            nodes++;
            return evalPosition();
        }

        nodes++;

        if (board.repeatedBoard() || board.checkEnd())
        {
            return 0;
        }

        if (ply >= 64)
            return evalPosition();

        MoveList ml;
        ml = genMoves(board.SB);

        int legal = cast(int)(ml.length);
        int oldAlpha = alpha;
        Move bestMove = emptyMove;
        int score = -inf;

        foreach (m; ml.moves)
        {
            board.makeMove(m);
            ply++;
            score = -alphaBeta(-beta, -alpha, depth-1);
            board.unMakeMove();
            ply--;

            if (score > alpha)
            {
                if (score >= beta)
                {
                    return beta;
                }
                alpha = score;
                bestMove = m;
            }

        }

        debug
        {
            import std.stdio;
            writefln("Move: %s\nScore: %s\n", bestMove, score);
        }

        if (legal == 0)
        {
            if (board.turn && squareAttacked(bKing, board.SB, WHITE))
                return -mate + ply;
            else if (squareAttacked(wKing, board.SB, BLACK))
                return -mate + ply;
            else
                return 0;
        }

        if (alpha != oldAlpha)
        {
            PVarray[ply] = bestMove;
        }

        return alpha;
    }
}
