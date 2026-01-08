
#include "Board.hpp"

using namespace ajd::tictactoe3d;

void testBoard()
{
    const size_t ebene = 0;
    const size_t dEbene = 1;

    ajd::tictactoe3d::Board b;
    size_t sz = sizeof( b );

    for ( size_t i = 0; i < Board::BOARD_SIZE; i++ )
        b.setValue( ebene + i * dEbene, i, 0, Player::A );
    CheckResult_t res = b.checkWinner();

    b.reset();
    for ( size_t i = 0; i < Board::BOARD_SIZE; i++ )
        b.setValue( ebene + i * dEbene, 0, i, Player::A );
    res = b.checkWinner();

    b.reset();
    for ( size_t i = 0; i < Board::BOARD_SIZE; i++ )
        b.setValue( ebene + i * dEbene, 2, i, Player::A );
    res = b.checkWinner();

    b.reset();
    for ( size_t i = 0; i < Board::BOARD_SIZE; i++ )
        b.setValue( ebene + i * dEbene, i, i, Player::A );
    res = b.checkWinner();

    b.reset();
    for ( size_t i = 0; i < Board::BOARD_SIZE; i++ )
        b.setValue( ebene + i * dEbene, Board::BOARD_SIZE - i - 1, i, Player::A );
    res = b.checkWinner();
}

int main( int argc, char *argv[] )
{
    QGuiApplication app( argc, argv );

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []()
    {
        QCoreApplication::exit( -1 );
    },
    Qt::QueuedConnection );
    engine.loadFromModule( "Q3DTicTacToe", "Main" );

    testBoard();

    return app.exec();
}
