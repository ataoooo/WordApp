import QtQuick 2.0

//悬浮提示框框
Rectangle{
    id:chip
    width: txt.width + dp(8)
    height: txt.height + dp(6)
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: parent.bottom
    anchors.bottomMargin: dp(20)
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
    //动画
    PropertyAnimation{
        id:show
        target: chip
        running: false
        property: "opacity"
        from: 0
        to: 1
        //持续时间
        duration: 500
        //指定动态缓和曲线
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
        //间隔
        interval: 2000
        running: false
        repeat: false
        //调用stop后执行
        onTriggered: hide.start()
    }
    //show --- delay --- hide
    Component.onCompleted: show.start()
}
