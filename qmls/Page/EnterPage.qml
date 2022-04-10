import QtQuick 2.0
import "../Component"
import "../Page"

//登录后的主页面
Rectangle{
    id:page
    property var currentIndex: 0

    //上层布局
    Rectangle{
        id:tabView
        anchors{
            bottom: tabBar.top
            top: parent.top
            horizontalCenter: parent.horizontalCenter
        }
        width: parent.width
        color: "white"
        state: "词典"

        DirectoryPage{id:direPage}


        states: [
            State {
                name: "词典"
                PropertyChanges {target: direPage;opacity:1}
            }
        ]
    }

    //最下一栏
    Rectangle{
        id:tabBar
        width: parent.width
        height: dp(14)
        anchors.bottom: parent.bottom
        anchors.verticalCenter: parent.horizontalCenter
        Rectangle{

        }
    }
}
