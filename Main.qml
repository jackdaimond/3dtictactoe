import QtQuick

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")

    Rectangle {
        anchors {
            fill: parent
            margins: 50
        }
        border.width: 2
        border.color: "green"
        color: "yellow"
    }

}
