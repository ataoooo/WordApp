import QtQuick 2.0

//图标+文字
Rectangle{
    property var iconSource: ""
    property var iconText: ""
    width: parent.width
    height: parent.height
    color: "transparent"
    Image {
        id: image
        anchors{
            top: parent.top
            horizontalCenter: parent.horizontalCenter
        }
        source: iconSource
        width: parent.width
        height: parent.height * 0.6
        fillMode: Image.PreserveAspectFit
    }

    TextInput{
        id:lineText
        readOnly: true
        width: parent.width
        height: parent.height - image.height
        anchors.bottom: parent.bottom
        Text {
            text: iconText
            anchors.centerIn: parent
        }
    }

}
