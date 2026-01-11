import QtQuick

Window {
    id: root
    required property QtObject boardModel

    width: boardRow.width + 50
    height: boardRow.height + 50 + playerText.height
    visible: true
    title: qsTr("3D Tic Tac Toe")

    Component.onCompleted: {
        boardModel.currentPlayer = 1
    }

    Connections {
        target: boardModel
        function onWinnerDetected(winner)
        {
            console.log("Player " + winner + " hat gewonnen." )
            boardModel.reset()
            boardModel.currentPlayer = 1
        }

        function onValueChanged()
        {
            if(boardModel.currentPlayer === 1)
                boardModel.currentPlayer = 2
            else
                boardModel.currentPlayer = 1
        }
    }

    Text {
        id: playerText
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
        }

        property string currPlayerString: boardModel.currentPlayer === 1? "A" : "B"
        text: qsTr("Current Player: " + currPlayerString )
        font.pointSize: 24
    }

    Row {
        id: boardRow

        x: (parent.width - width) / 2
        y: (parent.height - height) / 2

        spacing: 10
        Repeater {
            model: 4
            TicTacToeBoard {
                id: board
                theModel: boardModel
                ebene: index
            }
        }
    }
}
