import game;

import std.stdio;

string welcome = "Welcome to GoatChess. Your one stop shop to playing chess against a computer.";

void main()
{
    writeln(welcome);

    Game g = new Game();
    g.play();
}
