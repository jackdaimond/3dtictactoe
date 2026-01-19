#pragma once



namespace ajd::tictactoe3d
{

class Board;

class BoardModel : public QObject
{
        Q_OBJECT

        Q_PROPERTY( int boardSize READ boardSize CONSTANT FINAL )
        Q_PROPERTY( int currentPlayer READ currentPlayer WRITE setCurrentPlayer NOTIFY currentPlayerChanged FINAL )

    public:
        explicit BoardModel( QObject *parent = nullptr );
        ~BoardModel();

        Q_INVOKABLE int value( size_t ebene, size_t x, size_t y ) const;
        Q_INVOKABLE void setValue( size_t ebene, size_t x, size_t y );
        Q_INVOKABLE void reset();

        int boardSize() const;

        int currentPlayer() const;
        void setCurrentPlayer( int newCurrentPlayer );

    Q_SIGNALS:
        void valueChanged( int boardIndex );
        void winnerDetected( int player );
        void boardReseted();

        void currentPlayerChanged();

    private:
        std::unique_ptr<Board> m_board;
        int m_currentPlayer = -1;
};

} //ajd::tictactoe3d
