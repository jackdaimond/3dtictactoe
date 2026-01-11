#include "BoardModel.hpp"

#include "Board.hpp"

namespace ajd::tictactoe3d
{

BoardModel::BoardModel( QObject *parent )
    : QObject{parent}
    , m_board( std::make_unique<Board>() )
{}

int BoardModel::value( size_t ebene, size_t x, size_t y ) const
{
    return static_cast<int>( m_board->value( ebene, x, y ) );
}

void BoardModel::setValue( size_t ebene, size_t x, size_t y )
{
    if ( m_board->value( ebene, x, y ) != Player::None )
        return;

    const auto theValue = static_cast<Player>( m_currentPlayer );
    m_board->setValue( ebene, x, y, theValue );

    Q_EMIT valueChanged( x + y * Board::BOARD_SIZE );

    const CheckResult_t res = m_board->checkWinner();
    if ( res )
    {
        Q_EMIT winnerDetected( static_cast<int>( res->first ) );
    }
}

void BoardModel::reset()
{
    m_board->reset();
    Q_EMIT boardReseted();
}

int BoardModel::boardSize() const
{
    return Board::BOARD_SIZE;
}

int BoardModel::currentPlayer() const
{
    return m_currentPlayer;
}

void BoardModel::setCurrentPlayer( int newCurrentPlayer )
{
    if ( m_currentPlayer == newCurrentPlayer )
        return;
    m_currentPlayer = newCurrentPlayer;
    emit currentPlayerChanged();
}

} //ajd::tictactoe3d
