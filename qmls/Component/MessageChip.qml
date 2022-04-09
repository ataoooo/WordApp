import QtQuick 2.0

Rectangle{
    id:chip
    width: txt.width + dp(8)
    height: txt.width + dp(6)
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: dp(20)
    color: "#505152"
    radius: width/5
    property alias text: txt.text
    Text {
        id: txt
        anchors.centerIn: parent
        text: "测试"
        font.pixelSize: dp(3.5)
        color: "white"
    }
    PropertyAnimation{
        id:show
        target: chip
        running: false
        property: "opacity"
        from: 0
        to: 1
        duration: 700
        easing.type: Easing.InQuint
        onStopped: delay.start()
    }
    PropertyAnimation{
        id:hide
        target: chip
        property: "opacity"
        from: 1
        to: 0
        duration: 700
        easing.type: Easing.OutQuart
        onStopped: this.destroy()
    }
    Timer{
        id:delay
        interval: 2000
        running: false
        repeat: false
        onTriggered: hide.start()
    }
    Component.onCompleted: show.start()
}
