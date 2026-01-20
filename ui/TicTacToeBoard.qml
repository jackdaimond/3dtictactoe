import QtQuick 2.15

Item {
    id: ctrl
    property QtObject theModel
    property int ebene: 0

    property color backColor: Qt.rgba(0, 0, 0.5, 1);

    width: grid.width
    height: grid.height

    // Rectangle {
    //     anchors.fill: parent
    //     color: "green"
    // }

    Item {
        id: privData

        readonly property int tileSize: 60

        property int boardHoverIndex: -1
        property int boardSize: ctrl.theModel.boardSize

        readonly property real myHeight: tileSize * (boardSize - 1)
        readonly property var uV: Qt.vector2d(tileSize - 1, myHeight - 1)
        readonly property real magnitude : uV.length()
        readonly property var dirV: Qt.vector2d(uV.x / magnitude, uV.y / magnitude)

        function setBoardHoverIndex(index)
        {
            if(index !== privData.boardHoverIndex)
            {
                privData.boardHoverIndex = index;
                grid.requestPaint();
            }
        }

        function boardCoordsFromCurrentIndex()
        {
            var dY = Math.floor(boardHoverIndex / boardSize) / 4
            var dX = Math.floor((boardHoverIndex / boardSize - dY * 4) * boardSize)

            return [dX, dY]
        }

    }

    Canvas {
        id: grid

        width: privData.tileSize * 4
        height: privData.tileSize * 3

        readonly property real magnitude : privData.magnitude

        onPaint: {
            var ctx = getContext("2d");

            var myHeight = privData.tileSize * 3
            var tileWidth = myHeight / 4
            var tileHeight = myHeight / 4

            const dirV = [privData.dirV.x, privData.dirV.y]

            ctx.strokeStyle = Qt.rgba(1, 1, 1, 1);
            ctx.fillStyle = ctrl.backColor
            ctx.lineWidth = 1;

            ctx.beginPath();
            {
                ctx.moveTo(1, 1);
                ctx.lineTo(privData.tileSize, myHeight - 1);
                ctx.lineTo(privData.tileSize * 4, myHeight- 1);
                ctx.lineTo(privData.tileSize * 4 - privData.tileSize, 1);
                ctx.lineTo(1, 1);
                ctx.fill()

                for(let i = 0.25; i < 1.0; i += 0.25)
                {
                    ctx.moveTo(dirV[0] * i * magnitude, dirV[1] * i * magnitude)
                    ctx.lineTo(dirV[0] * i * magnitude + myHeight, dirV[1] * i * magnitude)

                    ctx.moveTo(tileWidth * i * 4, 1)
                    ctx.lineTo(tileWidth * (i * 4) + privData.tileSize , myHeight - 1)
                }

            }
            ctx.stroke();

            if(privData.boardHoverIndex !== -1)
            {
                ctx.beginPath()
                {
                    ctx.fillStyle = Qt.color("orange")

                    var dY = Math.floor(privData.boardHoverIndex / privData.boardSize) / 4
                    var dX = Math.floor((privData.boardHoverIndex / privData.boardSize - dY * 4) * privData.boardSize)

                    const startX = privData.dirV.x * dY * magnitude + 2 + dX * privData.myHeight / 4
                    const startY = privData.dirV.y * dY * magnitude + 2

                    const endX = privData.dirV.x * (dY + 0.25) * magnitude + 2 + dX * privData.myHeight / 4
                    const endY = privData.dirV.y * (dY + 0.25) * magnitude - 1

                    ctx.moveTo(startX, startY)
                    ctx.lineTo(endX, endY)
                    ctx.lineTo(endX + privData.myHeight / 4 - 4, endY)
                    ctx.lineTo(startX + privData.myHeight / 4 - 4, startY)
                    ctx.lineTo(startX, startY)
                }
                ctx.fill()
            }

        }
    }

    MouseArea {
        id: mouseHandler
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        hoverEnabled: true

        function mouseToBoardCoord(mouseX, mouseY) {

            const dY = mouseY / privData.myHeight
            const y = Math.min(3.0, Math.floor(dY * privData.boardSize))

            const startX = privData.dirV.x * privData.magnitude * dY
            const mouseXNorm = mouseX - startX
            var x = -1
            if(mouseXNorm >= 0)
            {
                var dX = mouseXNorm / privData.myHeight;
                x = Math.min(3.0, Math.floor(dX * privData.boardSize))
            }

            return [x, y];
        }

        onClicked: (mouse) => {
            const boardCoords = mouseToBoardCoord(mouse.x, mouse.y);

            theModel.setValue(ctrl.ebene, boardCoords[0], boardCoords[1])
        }

        onPositionChanged: (mouse) => {
            const boardCoords = mouseToBoardCoord(mouse.x, mouse.y);

            var newHoverIndex = -1;
            if(boardCoords[0] >= 0 && boardCoords[1] >= 0)
                newHoverIndex = boardCoords[1] * ctrl.theModel.boardSize + boardCoords[0]

            privData.setBoardHoverIndex(newHoverIndex)
        }

        onExited:
        {
            privData.setBoardHoverIndex(-1)
        }
    }

    // Grid
    // {
    //     id: grid2
    //     rows: theModel.boardSize
    //     columns: theModel.boardSize

    //     Repeater {
    //         model: theModel.boardSize * theModel.boardSize

    //         Rectangle {
    //             width: privData.tileSize; height: privData.tileSize
    //             border.width: 1
    //             color: mouseHandler.boardIndex === index? "orange" : "yellow"

    //             readonly property int boardX : index % theModel.boardSize
    //             readonly property int boardY : index / theModel.boardSize

    //             property int val : ctrl.theModel.value(ctrl.ebene, boardX, boardY)

    //             Text {
    //                 id: boardText
    //                 anchors.fill: parent
    //                 text: val === 1? 'X' : val === 2? 'O' : ''
    //                 font.pixelSize: privData.tileSize - 10

    //                 verticalAlignment: Text.AlignVCenter
    //                 horizontalAlignment: Text.AlignHCenter
    //             }

    //             Connections {
    //                 target: theModel
    //                 function onValueChanged(boardIndex)
    //                 {
    //                     if(boardIndex === index)
    //                         val = ctrl.theModel.value(ctrl.ebene, boardX, boardY)
    //                 }
    //                 function onBoardReseted()
    //                 {
    //                     val = ctrl.theModel.value(ctrl.ebene, boardX, boardY)
    //                 }
    //             }
    //         }
    //     }
    // }
    // MouseArea {
    //     id: mouseHandler
    //     anchors.fill: grid
    //     acceptedButtons: Qt.LeftButton
    //     hoverEnabled: true

    //     property int boardIndex: -1

    //     function mouseToBoardCoord(mouseCoord) {
    //         return Math.floor(mouseCoord / privData.tileSize)
    //     }

    //     onClicked: (mouse) => {
    //         var boardX = mouseToBoardCoord(mouse.x)
    //         var boardY = mouseToBoardCoord(mouse.y)

    //         theModel.setValue(ctrl.ebene, boardX, boardY)
    //     }

    //     onPositionChanged: (mouse) => {
    //         var boardX = mouseToBoardCoord(mouse.x)
    //         var boardY = mouseToBoardCoord(mouse.y)

    //         mouseHandler.boardIndex = boardY * ctrl.theModel.boardSize + boardX
    //     }

    //     onExited: boardIndex = -1
    // }

}
