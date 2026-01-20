#include "Board.hpp"

namespace ajd
{
namespace tictactoe3d
{

Board::Board()
{
    reset();
}

Player Board::value( size_t ebene, size_t x, size_t y ) const
{
    const size_t idx = indexOf( ebene, x, y );
    assert( idx < m_board.size() );

    return m_board[idx];
}

void Board::setValue( size_t ebene, size_t x, size_t y, Player value )
{
    const size_t idx = indexOf( ebene, x, y );
    assert( idx < m_board.size() );

    m_board[idx] = value;
}

void Board::resetValue( size_t ebene, size_t x, size_t y )
{
    setValue( ebene, x, y, Player::None );
}

void Board::reset()
{
    for ( Player &p : m_board )
        p = Player::None;
}

CheckResult_t Board::checkWinner() const
{
    CheckResult_t res;

    for ( size_t e = 0; e < BOARD_SIZE; e++ )
    {
        res = checkWinner( e, 0 );
        if ( res )
            return std::move( res );
    }
    res = checkWinner( 0, 1 );
    if ( res )
        return std::move( res );

    res = checkWinner( BOARD_SIZE - 1, -1 );
    if ( res )
        return std::move( res );

    return {};
}

CheckResult_t Board::checkWinner( size_t ebene, int dEbene ) const
{
    CheckResult_t result;

    for ( size_t x = 0; x < BOARD_SIZE; x++ )
    {
        result = checkWinner( ebene, x, 0, dEbene, 0, 1 );
        if ( result )
            return std::move( result );
    }
    for ( size_t y = 0; y < BOARD_SIZE; y++ )
    {
        result = checkWinner( ebene, 0, y, dEbene, 1, 0 );
        if ( result )
            return std::move( result );
    }

    if ( dEbene != 0 )
    {
        for ( size_t x = 0; x < BOARD_SIZE; x++ )
        {
            for ( size_t y = 0; y < BOARD_SIZE; y++ )
            {
                result = checkWinner( ebene, x, y, dEbene, 0, 0 );
                if ( result )
                    return std::move( result );
            }
        }
    }

    result = checkWinner( ebene, 0, 0, dEbene, 1, 1 );
    if ( result )
        return std::move( result );
    result = checkWinner( ebene, BOARD_SIZE - 1, 0, dEbene, -1, 1 );
    if ( result )
        return std::move( result );

    return {};
}

inline size_t bla( size_t &val, int dVal )
{
    if ( dVal == 0 )
        return val + 1;
    if ( dVal < 0 )
    {
        val = 0;
        dVal = -dVal;
    }
    return val + dVal * Board::BOARD_SIZE;
}

CheckResult_t Board::checkWinner( size_t ebene, size_t x, size_t y, int dEbene, int dX, int dY ) const
{
    Player result = Player::None;
    std::vector<BoardCoordinate> resCoords;
    resCoords.reserve( BOARD_SIZE );

    for ( size_t i = 0; i < BOARD_SIZE; i++ )
    {
        const int idx = indexOf( ebene, x, y );
        if ( m_board[idx] == Player::None )
            return {};

        const auto val = m_board[idx];

        if ( result == Player::None )
            result = m_board[idx];
        else if ( result != val )
            return {};
        resCoords.emplace_back( ebene, x, y );

        ebene += dEbene;
        x += dX;
        y += dY;
    }

    if ( result == Player::None )
        return {};
    return std::make_pair( result, std::move( resCoords ) );
}

} // namespace tictactoe3d
} // namespace ajd
