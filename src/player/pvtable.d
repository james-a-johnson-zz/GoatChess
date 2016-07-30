module player.pvtable;

import chess.defs;
import chess.move;

struct PVEntry
{
    U64 posKey;
    Move m;
}

class PVTable
{
    int size = void;
    PVEntry[] table = void;

    this(int s)
    {
        size = s;
        table = new PVEntry[s];
    }
}
