import QtQuick 2.15

Item {
    id: ctrl
    property QtObject theModel
    property int ebene: 0

    width: grid.width
    height: grid.height

    Item {
        id: privData

        readonly property int tileSize: 40
    }

    Grid
    {
        id: grid
        rows: theModel.boardSize
        columns: theModel.boardSize

        Repeater {
            model: theModel.boardSize * theModel.boardSize

            Rectangle {
                width: privData.tileSize; height: privData.tileSize
                border.width: 1
                color: mouseHandler.boardIndex === index? "orange" : "yellow"

                readonly property int boardX : index % theModel.boardSize
                readonly property int boardY : index / theModel.boardSize

                property int val : ctrl.theModel.value(ctrl.ebene, boardX, boardY)

                Text {
                    id: boardText
                    anchors.fill: parent
                    text: val === 1? 'X' : val === 2? 'O' : ''
                    font.pixelSize: privData.tileSize - 10

                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }

                Connections {
                    target: theModel
                    function onValueChanged(boardIndex)
                    {
                        if(boardIndex === index)
                            val = ctrl.theModel.value(ctrl.ebene, boardX, boardY)
                    }
                    function onBoardReseted()
                    {
                        val = ctrl.theModel.value(ctrl.ebene, boardX, boardY)
                    }
                }
            }
        }
    }
    MouseArea {
        id: mouseHandler
        anchors.fill: grid
        acceptedButtons: Qt.LeftButton
        hoverEnabled: true

        property int boardIndex: -1

        function mouseToBoardCoord(mouseCoord) {
            return Math.floor(mouseCoord / privData.tileSize)
        }

        onClicked: (mouse) => {
            var boardX = mouseToBoardCoord(mouse.x)
            var boardY = mouseToBoardCoord(mouse.y)

            theModel.setValue(ctrl.ebene, boardX, boardY)
        }

        onPositionChanged: (mouse) => {
            var boardX = mouseToBoardCoord(mouse.x)
            var boardY = mouseToBoardCoord(mouse.y)

            mouseHandler.boardIndex = boardY * ctrl.theModel.boardSize + boardX
        }

        onExited: boardIndex = -1
    }

}
