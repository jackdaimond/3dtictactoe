#pragma once

#include <cstdint>

namespace ajd
{
namespace tictactoe3d
{

enum class Player : uint8_t
{
    None,
    A,
    B
};

struct BoardCoordinate
{
    BoardCoordinate() {}
    BoardCoordinate( size_t ebene, size_t x, size_t y )
        : Ebene( ebene ), X( x ), Y( y )
    {
    }

    size_t Ebene;
    size_t X;
    size_t Y;
};

using CheckResult_t = std::optional<std::pair<Player, std::vector<BoardCoordinate>>>;

class Board
{
    public:
        static const size_t BOARD_SIZE = 4;
    public:
        Board();

        Player value( size_t ebene, size_t x, size_t y ) const;
        void setValue( size_t ebene, size_t x, size_t y, Player value );
        /// Resets the value on the board.
        ///
        /// This is the same like the call to setValue(ebene, x, y, Player::None);
        void resetValue( size_t ebene, size_t x, size_t y );

        void reset();

        CheckResult_t checkWinner() const;

    private:
        constexpr size_t indexOf( size_t ebene, size_t x, size_t y ) const
        {
            return ( ebene * BOARD_SIZE * BOARD_SIZE ) + ( y * BOARD_SIZE ) + x;
        }

        CheckResult_t checkWinner(size_t ebene , int dEbene) const;
        CheckResult_t checkWinner( size_t ebene, size_t x, size_t y, int dEbene, int dX, int dY ) const;

    private:
        std::array<Player, BOARD_SIZE *BOARD_SIZE *BOARD_SIZE> m_board;
};

} // namespace tictactoe3d
} // namespace ajd
