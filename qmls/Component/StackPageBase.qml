import QtQuick 2.12
import QtQuick.Controls 2.12

/////此处为三级页面的基础，此处实现了顶部的header和点击箭头按钮返回的功能
Page {
    //anchors.fill: parent;
    property alias _title:_title.text;
    header: Rectangle{
        color: allColor;
        width: parent.width;
        height: dp(15);
        Text {
            id: _title;
            anchors.centerIn: parent;
            text: "TEST PAGE";
            color: "white";
            font.pixelSize: dp(4);
        }
        Image {
            id: popIco;
            source: "../../assets/mdpi/ic_arrow_back.png";
            height: parent.height * 0.6;
            anchors{
                left: parent.left;
                leftMargin: dp(3);
                verticalCenter: parent.verticalCenter;
            }
            fillMode: Image.PreserveAspectFit;
            MouseArea {
                anchors.fill: parent;
                onClicked: stack.pop();
            }
        }//退出按钮

    }//顶部粉色Rect
    Rectangle {
        anchors.fill: parent;
        color: "#eeeeee";
    }
}
