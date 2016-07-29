module chess.defs;

alias U64 = ulong;

// Colors
enum WHITE = false;
enum BLACK = true;

// List of all the pieces. Used in the pieces array for the board.
enum Piece : ubyte
{
    empty,
    pawn,
    knight,
    bishop,
    rook,
    queen,
    king,
    Pawn,
    Knight,
    Bishop,
    Rook,
    Queen,
    King
}

enum Castle : ubyte
{
    King  = 0b00000001,
    Queen = 0b00000010,
    king  = 0b00000100,
    queen = 0b00001000
}
