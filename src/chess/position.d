module chess.position;

import chess.defs;

struct Position
{
    int row;
    int col;

    debug
    {
    string toString() const
    {
        if (row == -1)
            return "None";

        string p = "";
        p ~= 'a' + col;
        p ~= '8' - row;
        return p;
    }
    }
}
