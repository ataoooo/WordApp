import QtQuick 2.0
import QtQuick 2.12
import QtQuick.Controls 2.5
Rectangle{
    id:listItem
    width: dp(100)
    height: dp(10)
    color: "white"
    property alias text: txt.text
    property alias content: content.text
    property var popWindow
    Text {
        id: txt
        anchors{
            left: parent.left
            leftMargin: dp(4)
            verticalCenter: parent.verticalCenter
        }
        font.pixelSize: dp(3.5)
        text: "test"
    }
    Text {
        id: content
        anchors{
            right: arr.left
            rightMargin: dp(4)
            verticalCenter: parent.verticalCenter
        }
        font.pixelSize: dp(3.5)
    }
    MouseArea{
        anchors.fill: parent
        onClicked: {
            console.log("The name is = ",txt.text.substring(0,4))
            root.userKey = txt.text.substring(0,4)
            root.userValue = txt.text.substring(6)
            console.log("The key and value is = ",root.userKey,"  and:",root.userValue)
            root.pushStack(6)
        }
    }
}
