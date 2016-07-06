module chess.position;

struct Position
{
    int row;
    int column;

    string toString() const
    {
        if (row == -1)
            return "None";

        string p = "";
        p ~= 'a' + column;
        p ~= '8' - row;
        return p;
    }
}
