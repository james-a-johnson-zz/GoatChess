/*
    The board module will represent a chess board.
    It will be a simple 8x8 array of pieces.
 */

module chess.board;

import chess.defs;
import chess.move;
import chess.position;
import chess.simpleboard;

import std.container : Array;
import std.conv;
import std.format : formattedRead;
import std.random : XorshiftEngine;
import std.stdio;
import std.string;

// TODO(jjohnson): Do I still need these?
// Don't think I need these so they will be commented out for now.
// immutable ubyte whiteMask = 0b10000000;
// immutable ubyte blackMask = 0b01000000;

// The fen string that represents the starting position of a normal game of chess.
// TODO(jjohnson): Maybe add some other game types?
// string startFen = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1";
string startFen = "2rr3k/pp3pp1/1nnqbN1p/3pN3/2pP4/2p3Q1/PPB4P/R4RK1 w - - 10 10";

/*
    A bunch of random numbers to use for creating the unique board ID.
*/
U64[13][8][8] pieceKeys;
U64           turnKey;
U64[16]       castleKeys;
U64[8][8]     enPasKeys;

/*
   Function to initialize all of the random values.
*/
static this()
{
    auto rnd = XorshiftEngine!(U64, 128u, 11u, 8u, 19u)(2);

    for (int i = 0; i < 8; i++)
    {
        for (int j = 0; j < 8; j++)
        {
            for (int k = 0; k < 13; k++)
            {
                pieceKeys[i][j][k] = rnd.front;
                rnd.popFront();
            }
        }
    }

    turnKey = rnd.front;
    rnd.popFront();

    for (int i = 0; i < 16; i++)
    {
        castleKeys[i] = rnd.front;
        rnd.popFront();
    }

    for (int i = 0; i < 8; i++)
    {
        for (int j = 0; j < 8; j++)
        {
            enPasKeys[i][j] = rnd.front;
            rnd.popFront();
        }
    }
}

/*
   Used for unmaking moves.
*/
struct HisBoard
{
    Piece[8][8] pieces;
    int ply;
    int hply;
    bool turn;
    ubyte castlePerm;
    Position enPas;
}

/*
    Notes about how this board thing works.
    Pieces - and 8x8 array of pieces that stores piece and location.
    Ply - boolean of whose turn it is. Whilte: false, Black: true.
    hply - fifty move counter.
    CastlePerm - Will have flags for each possible castling there is.
    enPas - Will hold square of possible enpas move or -1.
    BoardID - Will contain a unique ID for each possible board position. 2^64 should be enough.
*/
class Board
{
  private
  {
    Piece[8][8] pieces;

    int ply;
    int hply;
    ubyte castlePerm;
    Position enPas;

    Array!U64 boardIDs;
    Array!HisBoard history;
  }
    bool turn;

    this(string fen = startFen)
    {
        readFen(fen);
    }

    Board dup() const
    {
        Board d = new Board();

        d.pieces = pieces;
        d.ply = ply;
        d.hply = ply;
        d.castlePerm = castlePerm;
        d.enPas = enPas;

        return d;
    }

    void readFen(string fen)
    {
        int rank = 0;
        int file = 0;
        int index = 0;

        while (fen[index] != ' ')
        {
            switch(fen[index])
            {
                case 'k':
                    pieces[rank][file] = Piece.king;
                    file++;
                    break;
                case 'q':
                    pieces[rank][file] = Piece.queen;
                    file++;
                    break;
                case 'b':
                    pieces[rank][file] = Piece.bishop;
                    file++;
                    break;
                case 'n':
                    pieces[rank][file] = Piece.knight;
                    file++;
                    break;
                case 'r':
                    pieces[rank][file] = Piece.rook;
                    file++;
                    break;
                case 'p':
                    pieces[rank][file] = Piece.pawn;
                    file++;
                    break;
                case 'K':
                    pieces[rank][file] = Piece.King;
                    file++;
                    break;
                case 'Q':
                    pieces[rank][file] = Piece.Queen;
                    file++;
                    break;
                case 'B':
                    pieces[rank][file] = Piece.Bishop;
                    file++;
                    break;
                case 'N':
                    pieces[rank][file] = Piece.Knight;
                    file++;
                    break;
                case 'R':
                    pieces[rank][file] = Piece.Rook;
                    file++;
                    break;
                case 'P':
                    pieces[rank][file] = Piece.Pawn;
                    file++;
                    break;

                case '/':
                    rank++;
                    file = 0;
                    break;

                case '8':
                case '7':
                case '6':
                case '5':
                case '4':
                case '3':
                case '2':
                case '1':
                    int num = fen[index] - '0';
                    file += num;
                    break;

                default:
                    throw new Exception(format("Invalid fen character: %s", fen[index]));
            }

            index++;
        }

        index++;

        if (fen[index] == 'w')
            turn = false;
        else
            turn = true;

        index += 2;

        while (fen[index] != ' ')
        {
            if (fen[index] == 'K')
            {
                castlePerm ^= Castle.King;
                index++;
                continue;
            }
            if (fen[index] == 'Q')
            {
                castlePerm ^= Castle.Queen;
                index++;
                continue;
            }
            if (fen[index] == 'k')
            {
                castlePerm ^= Castle.king;
                index++;
                continue;
            }
            if (fen[index] == 'q')
            {
                castlePerm ^= Castle.queen;
                index++;
                break;
            }
            index++;
        }

        index++;

        if (fen[index] != '-')
        {
            enPas.row = (8 - (fen[index+1] - '0'));
            enPas.col = (fen[index] - 'a');
            index += 2;
        }
        else
        {
            enPas.row = -1;
            enPas.col = -1;
            index++;
        }

        index++;

        string nums = fen[index .. $];
        formattedRead(nums, "%d %d", &hply, &ply);

        updateKey();
    }

    Piece opIndex(int a, int b) const
    {
        return pieces[a][b];
    }

    // Only checks fifty move and three board repetition.
    bool checkEnd() const
    {
        if (hply >= 50)
            return true;

        int count = void;
        for (int i = 0; i < boardIDs.length; i++)
        {
            count = 0;
            for (int j = i + 1; j < boardIDs.length; j++)
                if (boardIDs[i] == boardIDs[j])
                    count ++;
            if (count >= 3)
                return true;
        }

        return false;
    }

    bool repeatedBoard() const
    {
        for (int i = 0; i < boardIDs.length-1; i++)
        {
            if (boardIDs[i] == boardIDs[$-1])
                return true;
        }
        return false;
    }

    void unMakeMove()
    {
        HisBoard hs = history[$-1];

        pieces = hs.pieces;
        castlePerm = hs.castlePerm;
        ply = hs.ply;
        hply = hs.hply;
        turn = hs.turn;
        enPas = hs.enPas;

        deleteKey();
        history.removeBack();
    }

    void addToHistory()
    {
        HisBoard hs;

        hs.pieces = pieces;
        hs.ply = ply;
        hs.hply = hply;
        hs.enPas = enPas;
        hs.castlePerm = castlePerm;
        hs.turn = turn;

        history.insertBack(hs);
    }

    void makeMove(Move m)
    {
        addToHistory();

        if (m.castle != 0)
        {
            if (m.castle == Castle.King)
            {
                pieces[7][6] = Piece.King;
                pieces[7][4] = Piece.empty;
                pieces[7][5] = Piece.Rook;
                pieces[7][7] = Piece.empty;
                castlePerm &= ~(Castle.King | Castle.Queen);
            }
            else if (m.castle == Castle.Queen)
            {
                pieces[7][2] = Piece.King;
                pieces[7][4] = Piece.empty;
                pieces[7][0] = Piece.empty;
                pieces[7][5] = Piece.Rook;
                castlePerm &= ~(Castle.King | Castle.Queen);
            }
            else if (m.castle == Castle.king)
            {
                pieces[0][6] = Piece.king;
                pieces[0][4] = Piece.empty;
                pieces[0][5] = Piece.Rook;
                pieces[0][7] = Piece.empty;
                castlePerm &= ~(Castle.king | Castle.Queen);
            }
            else if (m.castle == Castle.queen)
            {
                pieces[0][2] = Piece.king;
                pieces[0][4] = Piece.empty;
                pieces[0][0] = Piece.empty;
                pieces[0][5] = Piece.rook;
                castlePerm &= ~(Castle.king | Castle.queen);
            }
            else
                throw new Exception("Invalid castle move.");
        }
        else
        {
            pieces[m.to.row][m.to.col] = m.piece;
            pieces[m.from.row][m.from.col] = Piece.empty;
            if (m.to.row == enPas.row && m.to.col == enPas.col)
            {
                if (enPas.row == 2)
                    pieces[3][enPas.col] = Piece.empty;
                else
                    pieces[4][enPas.col] = Piece.empty;
            }
            if (m.promotion != Piece.empty)
                pieces[m.to.row][m.to.col] = m.promotion;
        }

        enPas.row = m.enPas.row;
        enPas.col = m.enPas.col;

        if (m.piece == Piece.pawn)
            hply = 0;
        else if (m.capture != Piece.empty)
            hply = 0;
        else
            hply++;

        ply++;
        turn = !turn;
        updateKey();
    }

    void updateKey()
    {
        U64 boardID = 0;

        for (int i = 0; i < 8; i++)
        {
            for (int j = 0; j < 8; j++)
            {
                boardID ^= pieceKeys[i][j][pieces[i][j]];
            }
        }

        if (turn)
            boardID ^= turnKey;

        boardID ^= castleKeys[castlePerm];

        if (enPas.row != -1)
            boardID ^= enPasKeys[enPas.row][enPas.col];

        boardIDs.insertBack(boardID);
    }

    SimpleBoard SB() const @property
    {
        SimpleBoard sb;

        sb.pieces = pieces;
        sb.turn = turn;
        sb.castlePerm = castlePerm;
        sb.enPas = enPas;

        return sb;
    }

    void deleteKey()
    {
        boardIDs.removeBack();
    }

    U64 ID() @property const
    {
        return boardIDs[$-1];
    }

    void print() const
    {
        for (int i = 0; i < 8; i++)
        {
            write(format("%s ", 8-i));
            for (int j = 0; j < 8; j++)
            {
                switch(pieces[i][j])
                {
                    case Piece.empty:
                        write(". ");
                        break;
                    case Piece.pawn:
                        write("p ");
                        break;
                    case Piece.rook:
                        write("r ");
                        break;
                    case Piece.knight:
                        write("n ");
                        break;
                    case Piece.bishop:
                        write("b ");
                        break;
                    case Piece.queen:
                        write("q ");
                        break;
                    case Piece.king:
                        write("k ");
                        break;
                    case Piece.Pawn:
                        write("P ");
                        break;
                    case Piece.Rook:
                        write("R ");
                        break;
                    case Piece.Knight:
                        write("N ");
                        break;
                    case Piece.Bishop:
                        write("B ");
                        break;
                    case Piece.Queen:
                        write("Q ");
                        break;
                    case Piece.King:
                        write("K ");
                        break;

                    default:
                        throw new Exception("Invalid value in pieces array.");
                }
            }
            write("\n");
        }
        writeln("  A B C D E F G H");
        writeln();

        writeln("Move(s): ", ply);
        writeln("Fifty Move Counter: ", hply);
        writeln("Turn: ", turn ? "Black" : "White");
        writeln("En Passant: ", enPas);
        writefln("Castle Permissions: %b", castlePerm);
        writefln("Board ID: %X", ID);
        write("\n\n");
    }
}
