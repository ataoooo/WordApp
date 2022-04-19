import QtQuick 2.0
import QtQuick.Controls 2.5
Rectangle{
    property var leftTxt: ""
    property var rightTxt: ""
    property alias contexts: rightarea.text
    //左部文字
    Rectangle{
        id:leftRec
        height: parent.height
        width: dp(20)
        anchors.left: parent.left
        color: "#eeeeee"
        Text {
            anchors.centerIn: parent
            text: leftTxt
            font.pixelSize: dp(4)
        }
    }
    //右部文字
    TextField{
        id:rightarea
        height: parent.height
        width: parent.width - leftRec.width
        text: rightTxt
        font.pixelSize: dp(4)
        anchors.left: leftRec.right
        background: Rectangle{
            color: "transparent"
        }
    }
}
